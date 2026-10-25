# PRD — Migrazione iOS (IPA Unsigned) con Capacitor + GitHub Actions

## Task 1: Fase 1 — Audit del Progetto
- Analizzare completamente il repository (framework, dipendenze, build web, storage, API, compatibilità WebView/Capacitor, sicurezza).
- Verificare compilazione web, analisi statica e test in modo non distruttivo.
- Produrre il report `IOS_MIGRATION_AUDIT.md`.
- **Stato:** [x] Completato

## Task 2: Fase 2 — Preparazione della Versione iOS e Strategia Git
- Mantenere il branch `main` completamente intatto.
- Creare e posizionarsi sul branch dedicato `ios`.
- Aggiornare `.gitignore` per escludere segreti (`assets/.env`), dipendenze (`node_modules/`), log temporanei (`*.txt` di analisi/test) e file `.ipa` / `Payload/`.
- Creare `assets/.env.example` (senza chiavi reali) mantenendo `assets/.env` solo in locale (non tracciato da Git).
- Rendere compatibili con Web/Capacitor WebView i servizi che usano `dart:io` (`lib/services/storage_utils.dart`, `lib/services/csv_migration_service.dart`, `lib/services/csv_exporter.dart`, `lib/services/qr_migration_service.dart`) senza alterare il funzionamento esistente.
- Correggere il test obsoleto in `test/training_timer_test.dart` affinché l'intera suite `flutter test` passi al 100%.
- **Stato:** [x] Completato

## Task 3: Fase 3 — Installazione e Configurazione Capacitor
- Creare `package.json` con gli script per build web, sync Capacitor, lint e test.
- Installare `@capacitor/core`, `@capacitor/cli` e `@capacitor/ios`.
- Configurare `capacitor.config.json` con `appId: "com.races30.cubetrainer"`, `appName: "CubeTrainer"` e `webDir: "build/web"`.
- **Stato:** [x] Completato

## Task 4: Fase 4 — Prima Build Web, Lint e Test
- Eseguire `npm install`, `npm run lint` (`flutter analyze`), `npm test` (`flutter test`).
- Eseguire la build web di produzione (`npm run build:web` -> `flutter build web --release --base-href / --pwa-strategy=none`).
- Verificare che `build/web/index.html` abbia `<base href="/">` e che tutti gli asset siano presenti in `build/web`.
- **Stato:** [x] Completato

## Task 5: Fase 5 — Generazione e Configurazione Progetto iOS
- Spostare/archiviare il template iOS di default di Flutter (preservando `ios/StatsWidget/StatsWidget.swift` in `docs/StatsWidget.swift`) e generare il progetto iOS Capacitor (`npx cap add ios` + `npx cap sync ios`).
- Verificare la struttura `ios/App`, `Podfile` / dipendenze, deployment target, Bundle Identifier (`com.races30.cubetrainer`), Display Name (`CubeTrainer`), configurazioni Debug/Release e permessi fotocamera (`NSCameraUsageDescription`) in `ios/App/App/Info.plist`.
- **Stato:** [x] Completato

## Task 6: Fasi 6, 7, 8 — Workflow GitHub Actions, Versionamento Build e GitHub Release `latest-ios`
- Creare `.github/workflows/ios-build.yml` su runner `macos-latest`.
- Includere step per: checkout, setup Flutter e Node, creazione `assets/.env` sicura, installazione dipendenze, build web, iniezione metadati build (`BUILD_INFO.txt` e `build/web/build-info.json` con SHA, branch, versione, build number, data), `npx cap sync ios`, `pod install`, build Xcode unsigned (`CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO`), impacchettamento `CubeTrainer-unsigned.ipa`, verifica esistenza IPA, upload come GitHub Actions artifact, e pubblicazione/aggiornamento automatico della GitHub Release `latest-ios`.
- **Stato:** [x] Completato

## Task 7: Fasi 9 & 10 — Validazione Pipeline ed Esecuzione Reale su GitHub Actions
- Validare sintassi YAML, script `package.json`, configurazione Capacitor e struttura `ios/`.
- Controllare `git status` e `git diff` (nessun segreto, `main` intatto), eseguire commit e push del branch `ios`.
- Monitorare l'esecuzione reale su GitHub Actions fino al completamento con successo (`Completed` / `Success`).
- Verificare che l'IPA sia stata creata, caricata negli artifact e pubblicata nella GitHub Release `latest-ios` con il commit SHA corrispondente.
- **Stato:** [ ] Da eseguire

## Task 8: Fasi 11 & 12 — Documentazione `IOS_BUILD.md` e Controllo Finale Qualità e Sicurezza
- Creare la documentazione completa `IOS_BUILD.md` (punti A–L + sezione `"QUICK RELEASE"`).
- Eseguire tutti i controlli finali di qualità e sicurezza (`npm test`, `npm run lint`, `npm run build:web`, `npx cap sync ios`, verifica zero segreti/certificati nel repo).
- Eseguire commit e push finale sul branch `ios` e verificare che l'ultima run GitHub Actions sia verde e allineata.
- **Stato:** [ ] Da eseguire
