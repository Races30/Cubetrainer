# Documentazione App: CubeTrainer v2

Questa documentazione fornisce un'analisi dettagliatissima del funzionamento, dell'architettura e delle caratteristiche principali di **CubeTrainer v2**, un'applicazione avanzata sviluppata in Flutter per l'allenamento con il Cubo di Rubik (Speedcubing).

---

## 1. Panoramica dell'App

**CubeTrainer v2** è molto più di un semplice timer: è un assistente completo per lo speedcubing. Permette agli utenti di generare scramble formali (WCA compliant), cronometrare le proprie solve, analizzare le statistiche di miglioramento e ricevere raccomandazioni personalizzate tramite un **Coach AI** basato su LLM.

### Tecnologie e Stack Utilizzato

- **Framework UI:** Flutter (Multi-piattaforma, con enfasi Mobile).
- **State Management:** Riverpod (`flutter_riverpod`, `riverpod_annotation`). Fornisce reattività e gestione sicura e separata degli stati.
- **Local Database:** Hive (`hive`, `hive_flutter`). Database NoSQL veloce e senza schemi rigidi, ottimizzato per letture rapide in locale (storage solve, sessioni, messaggi storici).
- **Grafici e Statistiche:** `fl_chart` per la visualizzazione dell'andamento dei tempi e delle medie.
- **Intelligenza Artificiale:** `http` per interrogare l'API di OpenRouter (modello `openai/gpt-oss-120b:free` gestito in DeepSeekService).
- **Gestione Esportazioni:** `csv` e `share_plus` per l'esportazione / importazione (migrazione dati) delle solve.

---

## 2. Architettura e Struttura delle Cartelle

La codebase è strutturata seguendo un paradigma di separazione delle responsabilità:

- **`models/`**: Contiene le entità del dominio (Solve, TrainingSession, CoachMessage, CubeType, ecc.). Ognuna ha il suo `TypeAdapter` di Hive generato per la persistenza.
- **`screens/`**: Contiene i file di interfaccia utente. L'app si appoggia a un'architettura single-activity con una bottom navigation bar (`HomeNav`).
- **`services/`**: Raggruppa tutta la logica di business, le connessioni a servizi esterni e l'algoritmica (DeepSeekService, CrossSolver, ScrambleGenerator).
- **`providers/`**: Classi o dichiarazioni Riverpod per fare da collante tra `services`, `models` e la UI.

---

## 3. Navigazione e Schermate (UI/UX)

La navigazione principale avviene tramite il pannello inferiore (Bottom Navigation Bar) configurato in `home_nav.dart` e diviso in 4 Tab principali, oltre alla possibilità di selezionare il tipo di cubo (2x2 fino a 7x7, Megaminx, Pyraminx) dalla AppBar.

### 3.1 Scramble Tab (`scramble_screen.dart`)

- **Scopo:** Fornire scramble specifici per l'allenamento.
- **Funzionalità:**
  - Genera scramble validi che seguono la notazione standard mondiale (WCA).
  - Permette di generare scramble mirati in base alla fase o metodo (CFOP, Roux, ZZ) o all'esercizio desiderato (es. pratica Cross, F2L specifica, OLL/PLL).
  - Può interrogare l'intelligenza artificiale per farsi generare uno scramble di allenamento che si focalizza su pattern precisi (gestito da `DeepSeekService`).

### 3.2 Timer Tab (`timer_screen.dart`)

- **Scopo:** Cronometrare la solve dell'utente.
- **Funzionalità:**
  - Area sensitiva al tocco: tiene premuto per prepararsi ("Inspection") e rilascia per avviare il timer (comportamento standard dei timer per speedcubing come csTimer).
  - Mostra a schermo lo scramble in corso.
  - Al termine della risoluzione, il tempo viene formattato, associato all'algoritmo di scramble e alla data, e salvato istantaneamente nel database Hive.

### 3.3 Stats Tab (`stats_screen.dart`)

- **Scopo:** Visualizzazione approfondita delle metriche e tracciamento dei progressi.
- **Funzionalità:**
  - **Calcoli WCA Standard:** Computa automaticamente in tempo reale varie metriche, ad esempio: Best Time, Average (media totale o ritagliata), Ao5 (Average of 5) e Ao12 (Average of 12).
  - **Grafici Visivi:** Una rappresentazione visiva dei tempi (`fl_chart`) per cogliere subito i trend (up/down) della propria performance.
  - **Storico:** Elenco delle sessioni o solve passate. Consente l'analisi analitica delle solve precedenti o, qualora si rendesse necessario, l'eliminazione dei tempi falsati (+2, DNF o cancellazioni).

### 3.4 Coach Tab (`coach_screen.dart` & `deepseek_service.dart`)

- **Scopo:** Fornire consigli intelligenti di un vero coach.
- **Funzionalità AI:** Sfrutta le API esterne inviando statistiche dell'utente silenziose (Ao5, Ao12, Solve totali).
- **Gestione Prompt:** L'IA viene manipolata dietro le quinte definendo il suo ruolo ("Sei un allenatore professionista di speedcubing"), obbligandola a risposte dirette (max 10-12 righe), tecniche, che evidenzino i punti deboli e suggerendo esercizi (es: "drilla OLL 21").

---

## 4. Servizi, Funzionalità Avanzate e Algoritmi (Core Logic)

### 4.1 Cross Solver (`cross_solver.dart`)

È un modulo fondamentale avanzato volto all'aiuto nello studio e allenamento.

- **Obiettivo:** Dato uno scramble qualsiasi, deve restituire la serie minima di mosse per completare la croce bianca sul fondo.
- **Algoritmo (Depth-First Search Iterativo):** L'algoritmo effettua una ricerca iterativa e profonda (Iterative Deepening DFS). Questo assicura che trovi la soluzione assolutamente più breve matematicamente possibile (di solito ≤ 8 mosse per il 3x3).
- **Ottimizzazione:** Include tecniche di _pruning_ (potatura dell'albero di ricerca) come prevenire mosse ridondanti adiacenti opposte (es. eseguire `U` e poi `D`, se `D` e poi `U` è già stato esplorato).
- **Concorrenza:** Essendo una simulazione che richiede molta CPU, è eseguita dentro un _Isolate_ di Dart (`compute(_solveIsolate, scramble)`) affinché l'interfaccia non risulti bloccata durante l'elaborazione.

### 4.2 Storage e Gestione Dati (`Hive`)

Invece di SQLite, l'app usa **Hive**.

- I Box sono inizializzati e recuperati nel `main.dart` con una logica di robustezza (`_openBoxWithRecovery`), che cancella e ricrea un box se ci sono problemi di corruzione file (spesso frequente in ambienti di test/dev).
- Entità Persistite principali: Storico scramble, sessioni di allenamento, lista solve, messaggi del coach, classifica (Leaderboard).

### 4.3 Gestione Ambientale (.env) e Sicurezza

La protezione delle API Key (ad esempio di DeepSeek) e altri dati sensibili è affidata a `flutter_dotenv`. L'app cerca nel path `assets/.env`. Qualora non fosse configurata la chiave, la UI fallback restituisce un messaggio che invita l'utente alla configurazione, non andando in blocco (crash).

### 4.4 Importazione / Esportazione (`csv_migration_service.dart`)

Poiché spesso gli speedcuber provengono da altri timer (come _csTimer_ o _TwistyTimer_), il `CsvMigrationService` permette di importare backup strutturati tramite picker-file (modulato con la dipendenza `file_picker`), parser CSV personalizzati e l'esportazione delle proprie sessioni.

---

## 5. Dettagli sul Flusso dell'Utente

1. L'utente apre l'app e sceglie il tipo di cubo (es: 3x3) dalla barra alta che permane a prescindere dal Tab.
2. Genera uno scramble (o riceve quello predefinito per iniziare) nel primo o nel secondo tab ("Scramble" o "Timer"). L'IA può consigliare scramble specifici che vanno a testare un sotto-algoritmo (es. OLL).
3. Va nel "Timer", posiziona le dita sullo schermo aspettando che l'interfaccia del cronometro diventi verde per registrare la Inspection e parte per fare la sua Solve.
4. Quando ha finito, clicca per fermare. I dati salvati verranno letti dai provider delle stats per aggiornare un grafico live del trend, visibile in "Stats" e ricalcolando gli Ao5.
5. Quando in difficoltà, va nel tab "Coach" e chiede ad esempio _"Come scendo sotto i 15 secondi?"_ Il modulo raccoglie automaticamente le stats medie e gli risponde istruendo di effettuare specifici esercizi di _Lookahead_ o di migliorare il TPS in fase F2L, sapendo i suoi veri tempi attuali.

## 6. Sviluppi Futuri

Dal codice sorgente emergono tracce di:

- **Leaderboard Cloud:** È presente un `LeaderboardEntry` locale, ma l'impalcatura connetterebbe ad una base (es. Firebase o Supabase) per competere a livello globale.
- **Allenamenti Modalitari:** Schermate parziali scoperte in `screens` come `training_timer_screen.dart` ed esercizi legati a `TrainingSolve` mostrano l'implementazione o l'iter iterativo verso sessioni specifiche (a tempo, o di memorizzazione) parallele a quella a cronometro nudo e crudo.
