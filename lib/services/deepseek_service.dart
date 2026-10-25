import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:cubetrainer/models/solve.dart';
import 'package:cubetrainer/models/solving_method.dart';
import 'package:cubetrainer/models/exercise_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DeepSeekService {
  String get _apiKey {
    try {
      return dotenv.isInitialized ? (dotenv.env['DEEPSEEK_API_KEY'] ?? '') : '';
    } catch (_) {
      return '';
    }
  }

  final String _apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  // Note: _baseUrl, _maxRetries and _initialDelay are removed to clear analyzer warnings as they are currently unused.

  Future<http.Response> _makeDeepseekRequest(Map<String, dynamic> body) async {
    final headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    };

    final uri = Uri.parse(_apiUrl);
    return await http.post(uri, headers: headers, body: json.encode(body));
  }

  Future<String> getCoachResponse(
      String prompt, Map<String, dynamic> stats) async {
    if (_apiKey.isEmpty) {
      return 'Errore: Chiave API non configurata. Inserisci la tua chiave API in assets/.env.';
    }

    final String userMessage = '''
Statistiche:
- Solves: ${stats['totalSolves']}
- Best: ${stats['bestTime']}
- Avg: ${stats['averageTime']}
- Ao5: ${stats['ao5']}
- Ao12: ${stats['ao12']}
${stats['splits'] != null ? "- Splits medi: ${stats['splits']}\n" : ""}${stats['worstCases'] != null ? "- Casi peggiori OLL/PLL: ${stats['worstCases']}\n" : ""}${stats['sessionTrend'] != null ? "- Trend recente %: ${stats['sessionTrend']}\n" : ""}
Domanda: "$prompt"
''';

    // Fallback list of free models available on OpenRouter
    final freeModels = [
      'google/gemini-2.5-flash:free',
      'meta-llama/llama-3.3-70b-instruct:free',
      'openai/gpt-oss-120b:free',
      'deepseek/deepseek-r1-distill-llama-70b:free',
      'gryphe/mythomax-l2-13b:free'
    ];

    try {
      for (final model in freeModels) {
        final body = {
          'model': model,
          'messages': [
            {
              'role': 'system',
              'content': '''Sei un allenatore professionista di speedcubing.

Ruolo:
Il tuo compito è analizzare le performance dell'utente e fornire consigli tecnici realistici per migliorare i tempi.

Stile obbligatorio:
- Linguaggio tecnico ma chiaro.
- Niente emoticon.
- Niente motivazione generica.
- Niente discorsi lunghi.
- Niente divagazioni.
- Tono diretto e professionale, come un coach reale.

Struttura di ogni risposta:
1) Analisi diretta (cosa va bene / cosa va male).
2) Consigli tecnici concreti.
3) Esercizi pratici da fare.

Formato:
- Massimo 10-12 righe.
- Frasi brevi.
- Se possibile usa termini come: F2L, OLL, PLL, cross, lookahead, TPS, fingertrick, inspection, efficiency.
- Preferisci esempi concreti (“fai 10 solve solo cross”, “drilla OLL 21 e 57”, ecc.).

Quando ricevi statistiche:
- Evidenzia i punti deboli.
- Suggerisci cosa allenare prima.
- Dai un piano di allenamento pratico.

Quando ricevi una domanda generica:
- Rispondi sempre come un coach di cubing esperto, non come un chatbot.

Se inizi a usare frasi motivazionali, emoticon o testi troppo lunghi, stai fallendo il tuo compito.'''
            },
            {'role': 'user', 'content': userMessage},
          ],
          'max_tokens': 300,
        };

        final response = await _makeDeepseekRequest(body);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return data['choices'][0]['message']['content'];
        } else if (response.statusCode == 429) {
          // Rate limited, try the next model
          continue;
        } else {
          return 'Errore API: ${response.statusCode} - ${response.body}';
        }
      }
      return 'Errore: Tutti i modelli AI gratuiti sono attualmente sovraccarichi (Rate Limited). Riprova più tardi.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> generateDeepseekScramble(CubeType cubeType,
      SolvingMethod solvingMethod, ExerciseType exerciseType) async {
    if (_apiKey.isEmpty) {
      return 'Errore: Chiave API non configurata. Inserisci la tua chiave API in deepseek_service.dart.';
    }

    String cubeTypeName = cubeType.toString().split('.').last;
    String solvingMethodName = solvingMethod.toString().split('.').last;
    String exerciseTypeName = exerciseType.toString().split('.').last;

    // Convert enum names to a more readable format for the prompt
    switch (cubeType) {
      case CubeType.twoByTwo:
        cubeTypeName = '2x2 cube';
        break;
      case CubeType.threeByThree:
        cubeTypeName = '3x3 cube';
        break;
      case CubeType.fourByFour:
        cubeTypeName = '4x4 cube';
        break;
      case CubeType.fiveByFive:
        cubeTypeName = '5x5 cube';
        break;
      case CubeType.sixBySix:
        cubeTypeName = '6x6 cube';
        break;
      case CubeType.sevenBySeven:
        cubeTypeName = '7x7 cube';
        break;
      case CubeType.megaminx:
        cubeTypeName = 'Megaminx';
        break;
      case CubeType.pyraminx:
        cubeTypeName = 'Pyraminx';
        break;
    }

    switch (solvingMethod) {
      case SolvingMethod.cfop:
        solvingMethodName = 'CFOP';
        break;
      case SolvingMethod.roux:
        solvingMethodName = 'Roux';
        break;
      case SolvingMethod.zz:
        solvingMethodName = 'ZZ';
        break;
      case SolvingMethod.reduction:
        solvingMethodName = 'Reduction';
        break;
      case SolvingMethod.yau:
        solvingMethodName = 'Yau';
        break;
      case SolvingMethod.beginner:
        solvingMethodName = 'Beginner';
        break;
      case SolvingMethod.advanced:
        solvingMethodName = 'Advanced';
        break;
      case SolvingMethod.none:
        solvingMethodName = 'General';
        break;
    }

    switch (exerciseType) {
      case ExerciseType.cross:
        exerciseTypeName = 'Cross';
        break;
      case ExerciseType.f2l:
        exerciseTypeName = 'F2L';
        break;
      case ExerciseType.oll:
        exerciseTypeName = 'OLL';
        break;
      case ExerciseType.pll:
        exerciseTypeName = 'PLL';
        break;
      case ExerciseType.recognition:
        exerciseTypeName = 'Recognition';
        break;
      case ExerciseType.lookahead:
        exerciseTypeName = 'Lookahead/TPS';
        break;
      case ExerciseType.beautifulPatterns:
        exerciseTypeName = 'Beautiful Patterns';
        break;
      case ExerciseType.mixed:
        exerciseTypeName = 'Mixed Session';
        break;
      case ExerciseType.randomCube:
        exerciseTypeName = 'Migliori Tempi';
        break;
    }

    final String scramblePrompt = '''
      Genera uno scramble WCA-compliant per un $cubeTypeName, 
      specificamente per il metodo di risoluzione $solvingMethodName e l'esercizio $exerciseTypeName. 
      Assicurati che lo scramble sia valido e segua le convenzioni standard per i movimenti. 
      Fornisci solo lo scramble, senza testo aggiuntivo o spiegazioni.
    ''';

    // Fallback list of free models available on OpenRouter
    final freeModels = [
      'google/gemini-2.5-flash:free',
      'meta-llama/llama-3.3-70b-instruct:free',
      'openai/gpt-oss-120b:free',
      'deepseek/deepseek-r1-distill-llama-70b:free',
      'gryphe/mythomax-l2-13b:free'
    ];

    try {
      for (final model in freeModels) {
        final body = <String, dynamic>{
          'model': model,
          'messages': [
            {
              'role': 'system',
              'content': 'Sei un generatore di scramble WCA-compliant.'
            },
            {'role': 'user', 'content': scramblePrompt},
          ],
          'max_tokens': 1000,
        };

        final response = await _makeDeepseekRequest(body);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          String scramble = data['choices'][0]['message']['content'];
          scramble =
              scramble.replaceAll(RegExp(r'^```[a-zA-Z]*\n|\n```$'), '').trim();

          // Rimuove tutto il testo dopo la prima riga (presumendo che lo scramble sia sempre su una singola riga).
          int newlineIndex = scramble.indexOf('\n');
          if (newlineIndex != -1) {
            scramble = scramble.substring(0, newlineIndex).trim();
          }

          // Rimuove anche qualsiasi occorrenza residua di "begin_of_sentence" con i suoi delimitatori comuni.
          scramble = scramble
              .replaceAll(RegExp(r'\s*<\|\s*begin_of_sentence\s*\|\s*>'), '')
              .trim();
          scramble = scramble
              .replaceAll(RegExp(r'\s*\|\s*begin_of_sentence\s*\|\s*>'), '')
              .trim();
          scramble =
              scramble.replaceAll(RegExp(r'begin_of_sentence'), '').trim();

          return scramble;
        } else if (response.statusCode == 429) {
          // Rate limited, try the next model
          continue;
        } else {
          return 'Errore API Deepseek: ${response.statusCode} - ${response.body}';
        }
      }
      return 'Errore: Tutti i modelli AI gratuiti sono rate-limited. Riprova più tardi.';
    } catch (e) {
      return e.toString();
    }
  }
}

final deepSeekServiceProvider = Provider((ref) => DeepSeekService());
