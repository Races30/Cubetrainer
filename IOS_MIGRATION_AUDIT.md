# iOS Migration Audit — CubeTrainer (`IOS_MIGRATION_AUDIT.md`)

**Data Audit:** 25 Ottobre 2026  
**Repository:** `https://github.com/Races30/Cubetrainer.git`  
**Branch attuale:** `main`

---

## 1. Stato Attuale del Progetto

| Aspetto | Rilevamento nel Repository |
| :--- | :--- |
| **Framework reale** | **Flutter 3.38.3** (Dart 3.10.1) — **NON** è una web app React/Vite, bensì un'applicazione multipiattaforma Flutter (`pubspec.yaml`, `lib/`, `web/`, `ios/`, `android/`). |
| **Package Manager** | `flutter pub` (`pubspec.yaml` / `pubspec.lock`). Node `v22.20.0` e `npm 11.16.0` sono installati nel sistema ma non esiste ancora alcun `package.json`. |
| **Versione App** | `1.0.0+1` (`pubspec.yaml`). |
| **Comando di Sviluppo** | `flutter run -d chrome` (Web) / `flutter run` (Mobile/Desktop). |
| **Comando di Build Web** | `flutter build web --release` |
| **Directory Output Build Web** | `build/web` |
| **Bundler / Renderer Web** | Flutter Web Compiler (`dart2js` -> `main.dart.js`, CanvasKit/Skwasm, `flutter_bootstrap.js`). |
| **Routing** | Navigazione interna single-page tramite `BottomNavigationBar` (`HomeNav` in `lib/screens/home_nav.dart`) e `Navigator.push` (`MaterialPageRoute`). Non usa URL routing browser-dependent. |
| **Gestione Asset** | Dichiarati in `pubspec.yaml` (`assets/` e `assets/.env`), compilati da Flutter in `build/web/assets/`. |
| **API / Backend** | Chiamate HTTPS verso **OpenRouter API** (`https://openrouter.ai/api/v1/chat/completions`) tramite package `http` in `lib/services/deepseek_service.dart` e `lib/services/grok_service.dart`. |
| **Storage Locale** | **Hive** (`hive: ^2.2.3`, `hive_flutter: ^1.1.0`). Su Web (`kIsWeb == true`) usa **IndexedDB** nel browser/WebView; su nativo usa il file system (`getApplicationDocumentsDirectory()`). |
| **Service Worker / PWA** | `web/manifest.json` e `flutter_service_worker.js` generati da Flutter Web. |
| **Stato Build Web** | `build/web` compila correttamente, ma l'ultima build locale/GitHub Pages ha `<base href="/Cubetrainer/">` in `build/web/index.html`. |
| **Analisi Statica (`flutter analyze`)** | 0 errori bloccanti (solo `info` di stile/deprecazioni minori in `lib/` e 3 `warning` di variabili inutilizzate nei file di test). |
| **Test (`flutter test`)** | 20 test passati su 21. 1 test fallisce in `test/training_timer_test.dart` perché cerca l'etichetta obsoleta `"INIZIA ORA"` (sostituita nel widget da `"AVVIA TIMER ISPEZIONE"` / `"SALTA (PRONTO)"`). |
| **Stato Git** | Sul branch `main` (locale e remoto) è tracciato **solo `README.md`**. L'intero codice sorgente (`lib/`, `pubspec.yaml`, `web/`, `ios/`, ecc.) è attualmente **untracked** nella working directory. Esiste un branch remoto `origin/gh-pages` contenente la build web statica pubblicata su GitHub Pages. |

---

## 2. Compatibilità Capacitor vs Architettura Flutter

> [!IMPORTANT]
> **Rilevamento Architetturale Critico:**  
> Il prompt ipotizza una web app React/Vite da incapsulare con Capacitor, ma **CubeTrainer è un progetto Flutter** che possiede già sia il target Web (`web/`) sia il target nativo iOS (`ios/Runner.xcodeproj`).

Esistono quindi **due strategie tecniche** per ottenere il file `CubeTrainer-unsigned.ipa` tramite GitHub Actions su macOS:

### Strategia 1 — Flutter Web + Capacitor iOS (Come richiesto letteralmente nel prompt)
1. Si compila la versione web di Flutter (`flutter build web --release --base-href / --pwa-strategy=none`) producendo `build/web`.
2. Si aggiunge un `package.json` con `@capacitor/core`, `@capacitor/cli`, `@capacitor/ios` configurando `webDir: "build/web"`.
3. Capacitor incapsula `build/web` dentro una `WKWebView` iOS e GitHub Actions compila il progetto Xcode generato da Capacitor producendo l'IPA unsigned.
4. **Conflitto cartella `ios/`**: Poiché Flutter usa già la cartella `ios/` per il runner nativo, Capacitor sovrascriverebbe o entrerebbe in conflitto con `ios/` (a meno di sostituire `ios/` sul branch dedicato iOS con il progetto Xcode di Capacitor).

### Strategia 2 — Build iOS Nativa Flutter (Alternativa architetturalmente nativa, senza Capacitor)
1. Poiché l'app è già scritta in Flutter, su GitHub Actions (`macos-latest`) è possibile eseguire direttamente `flutter build ios --release --no-codesign` usando la cartella `ios/` nativa già presente nel progetto, impacchettando `Runner.app` in `CubeTrainer-unsigned.ipa`.
2. **Vantaggi**: Prestazioni native (Metal/Impeller a 60/120fps invece di CanvasKit in WebView), funzionamento immediato di tutte le librerie `dart:io` (`File`, `Directory`, `gzip`), `file_picker`, `share_plus`, `mobile_scanner` e `wakelock_plus`, senza dover aggiungere Node.js + Capacitor sopra Flutter.

---

## 3. Problemi Trovati

1. **Incompatibilità `dart:io` dentro WebView (se si usa Capacitor / Flutter Web):**
   - `lib/services/storage_utils.dart`: usa `Platform.isAndroid` e `Directory` (`dart:io`), che su Web/Capacitor (`kIsWeb == true`) lanciano `Unsupported operation: Platform._operatingSystem`.
   - `lib/services/csv_migration_service.dart` e `lib/services/csv_exporter.dart`: usano `File` (`dart:io`) e `result.files.single.path` (che su Web è sempre `null`, in quanto `file_picker` su Web restituisce `bytes`).
   - `lib/services/qr_migration_service.dart`: usa `gzip` di `dart:io` (`gzip.encode` / `gzip.decode`), che non è supportato sul runtime JS/Wasm di Flutter Web.
   - `lib/services/sparkline_generator.dart`: usa `getApplicationDocumentsDirectory()` e `File` (`dart:io`) (catturato silenziosamente dal `try/catch` in `HomeWidgetHelper`).
2. **Configurazione `<base href>` nella Build Web:**
   - La build web attuale in `build/web/index.html` usa `<base href="/Cubetrainer/">` per GitHub Pages. Dentro Capacitor (`capacitor://localhost`), un base-href diverso da `/` impedisce il caricamento di `flutter_bootstrap.js` e degli asset (schermata bianca).
3. **Service Worker in `WKWebView`:**
   - Il Service Worker di Flutter (`flutter_service_worker.js`) può causare problemi di registrazione o caching su protocollo `capacitor://`. Va disabilitato nella build per Capacitor con `--pwa-strategy=none`.
4. **Permessi Fotocamera mancanti su iOS (`Info.plist`):**
   - L'app usa `mobile_scanner` per la scansione dei QR code (`lib/screens/qr_scanner_screen.dart`), ma in `ios/Runner/Info.plist` manca la chiave obbligatoria `NSCameraUsageDescription` (su iOS l'app va in crash all'apertura della fotocamera se questa chiave è assente).
5. **Sicurezza — Chiave API reale in `assets/.env`:**
   - Il file `assets/.env` contiene una chiave `DEEPSEEK_API_KEY=sk-or-v1-...` in chiaro e non è in `.gitignore`. Non deve essere committata nel repository: va esclusa tramite `.gitignore` e gestita tramite GitHub Secrets durante la build CI.
6. **Stato Git incompleto e file temporanei nella root:**
   - Sul branch `main` è committato solo `README.md`. Nella root sono presenti oltre 40 file `.txt` di log/test temporanei (`analyze_*.txt`, `test_*_out.txt`) che non vanno committati.
7. **Unit Test disallineato (`test/training_timer_test.dart`):**
   - Il test `"Clicking 'INIZIA ORA' should skip inspection and go to READY"` cerca il testo `"INIZIA ORA"`, ma `TrainingTimer` ora mostra `"AVVIA TIMER ISPEZIONE"` e poi `"SALTA (PRONTO)"`.

---

## 4. Modifiche Necessarie (in base alla strategia scelta)

1. **Gestione Git e Pulizia (Comune):**
   - Lasciare `main` completamente intatto.
   - Creare il branch dedicato (es. `ios-release` o `ios`).
   - Aggiornare `.gitignore` per escludere i file di log temporanei (`*.txt` di analisi/test), `assets/.env`, e gli artifact di build.
   - Gestire `assets/.env` in modo sicuro (file `.env` generato in CI da secret o vuoto di fallback, mai committato con chiavi reali).
2. **Se si procede con Capacitor (Strategia 1):**
   - Creare `package.json` e `capacitor.config.json` (o `.ts`) con `appId: "com.cubetrainer.app"`, `appName: "CubeTrainer"`, `webDir: "build/web"`.
   - Aggiungere script npm che eseguano `flutter build web --release --base-href / --pwa-strategy=none` seguito da `npx cap sync ios`.
   - Generare il progetto iOS Capacitor (`npx cap add ios`), configurando Bundle ID, versione, deployment target e `NSCameraUsageDescription` in `Info.plist`.
   - Rendere web-safe i servizi che usano `dart:io` (`csv_migration_service.dart`, `qr_migration_service.dart`) se devono funzionare dentro la WebView di Capacitor.
3. **Se si procede con Flutter iOS Nativo (Strategia 2) o Ibrido:**
   - Aggiornare `ios/Runner/Info.plist` aggiungendo `NSCameraUsageDescription`.
   - Configurare Bundle ID e metadati di versione/build.
4. **Pipeline GitHub Actions (`.github/workflows/ios-build.yml`):**
   - Runner `macos-latest`.
   - Installazione Flutter + (Node/Capacitor se Strategia 1) + CocoaPods.
   - Build di produzione + iniezione metadati (commit SHA, branch, versione, build number, data).
   - Compilazione Xcode unsigned (`CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO`).
   - Creazione `CubeTrainer-unsigned.ipa`, upload come GitHub Actions Artifact e pubblicazione/aggiornamento automatico sulla GitHub Release `latest-ios`.

---

## 5. Rischi Identificati

| Rischio | Impatto | Mitigazione |
| :--- | :--- | :--- |
| **Persistenza IndexedDB in `WKWebView` (Capacitor)** | Medio/Alto | Su iOS, i dati IndexedDB/localStorage dentro `WKWebView` possono essere rimossi dal sistema operativo in caso di pressione sulla memoria. (Nella build Flutter iOS nativa invece Hive scrive su file system nativo in `Documents`). |
| **Prestazioni Timer e Touch Latency in WebView** | Medio | Flutter Web (CanvasKit/Wasm) dentro `WKWebView` ha un overhead maggiore rispetto al motore nativo Impeller su iOS. |
| **Esposizione Secret (`assets/.env`)** | Alto | Rimuovere la chiave reale dal tracciamento Git, inserirla in `.gitignore` e generare `assets/.env` dinamicamente nel workflow GitHub Actions. |
| **Visibilità Repository GitHub e Release** | Medio | Il repository `Races30/Cubetrainer` attualmente risponde via HTTPS pubblico (ed espone GitHub Pages). Su GitHub una Release appartiene alla visibilità del repository: può essere marcata come `prerelease` o `draft`, ma la visibilità effettiva dipende dal fatto che il repo sia privato o pubblico. |

---

## 6. Piano di Migrazione (Fasi 2 – 12)

1. **Decisione Architetturale (Stop & Conferma Utente):** Confermare se procedere con **Capacitor sopra Flutter Web** (Strategia 1, fedele alla richiesta letterale) oppure con **Flutter iOS Nativo** (Strategia 2), e confermare `appId` / `appName`.
2. **Fase 2 (Git Strategy):** Creazione branch dedicato `ios` (mantenendo `main` intatto), pulizia `.gitignore` e messa in sicurezza di `assets/.env`.
3. **Fase 3 (Configurazione Capacitor / iOS):** Setup `package.json`, `@capacitor/core`, `@capacitor/cli`, `@capacitor/ios` con `webDir: "build/web"` (o configurazione nativa `ios/`).
4. **Fase 4 (Verifica Build & Test):** Fix del test `training_timer_test.dart`, esecuzione `flutter analyze`, `flutter test` e `flutter build web --release --base-href / --pwa-strategy=none`.
5. **Fase 5 (Progetto iOS):** Generazione/sincronizzazione `ios/` (`npx cap sync ios`), verifica `Podfile`, deployment target, Bundle ID (`com.cubetrainer.app`), `Info.plist` (`NSCameraUsageDescription`).
6. **Fasi 6, 7, 8 (GitHub Actions + Build Metadata + Release `latest-ios`):** Creazione workflow `.github/workflows/ios-build.yml` su `macos-latest` per generare `CubeTrainer-unsigned.ipa`, allegare `BUILD_INFO.txt` (SHA, branch, versione, data), caricare l'artifact e aggiornare il tag/release `latest-ios`.
7. **Fasi 9 & 10 (Validazione Reale Pipeline):** Push del branch `ios`, esecuzione reale della GitHub Action su GitHub, verifica del completamento (`Success`), dell'artifact e della release `latest-ios`.
8. **Fasi 11 & 12 (Documentazione & Sicurezza):** Creazione di `IOS_BUILD.md` completo di sezione *QUICK RELEASE* e controllo finale di qualità e sicurezza.
