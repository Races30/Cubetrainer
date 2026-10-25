# Guida Build e Release iOS — CubeTrainer (`IOS_BUILD.md`)

Questa documentazione descrive l'intero flusso di lavoro per modificare l'applicazione **CubeTrainer**, generare una nuova build iOS **unsigned (`CubeTrainer-unsigned.ipa`)** tramite **Capacitor + GitHub Actions su macOS** e pubblicarla automaticamente nella GitHub Release **`latest-ios`**, senza bisogno di avere un Mac o Xcode in locale.

---

## ⚡ QUICK RELEASE (Percorso Minimo per una Nuova IPA)

Quando hai modificato il codice dell'app (in `lib/`) e vuoi ottenere subito una nuova `CubeTrainer-unsigned.ipa` pronta per l'installazione su iPhone:

```bash
# 1. Assicurati di essere sul branch dedicato iOS
git checkout ios

# 2. (Opzionale ma consigliato) Verifica che test e build web funzionino in locale
npm test
npm run build:web
npm run cap:sync

# 3. Controlla le modifiche, fai commit e invia su GitHub
git status
git add .
git commit -m "feat: descrizione chiara della modifica"
git push origin ios
```

**Cosa succede automaticamente dopo il `git push origin ios`:**
1. Parte il workflow GitHub Actions **`Build iOS Unsigned IPA`** su un runner `macos-latest`.
2. Vengono eseguiti lint, test, `flutter build web`, `npx cap sync ios`, `pod install` e `xcodebuild` (unsigned).
3. Viene generato il file **`CubeTrainer-unsigned.ipa`** con i metadati del commit.
4. L'IPA viene caricata sia negli **Artifacts** della run sia nella GitHub Release **`latest-ios`**:
   - 👉 `https://github.com/Races30/Cubetrainer/releases/tag/latest-ios`

---

## A. Come creare/modificare la Web App

L'applicazione è sviluppata in **Flutter** (codice sorgente in `lib/`, asset in `assets/`, configurazione in `pubspec.yaml`).
1. Posizionati sul branch `ios`:
   ```bash
   git checkout ios
   ```
2. Modifica i file Dart dentro `lib/` (schermate in `lib/screens/`, logica in `lib/services/`, componenti in `lib/widgets/`).
3. Per testare l'app nel browser in modalità sviluppo:
   ```bash
   npm run dev
   # equivalente a: flutter run -d chrome
   ```
4. Per eseguire i controlli di qualità (analisi statica e test):
   ```bash
   npm run lint
   npm test
   ```

---

## B. Come creare una nuova Build Web per iOS

La build web destinata a Capacitor deve avere `<base href="/">` e il Service Worker disattivato (`--pwa-strategy=none`) per funzionare correttamente dentro la `WKWebView` di iOS.

Esegui il comando configurato in `package.json`:
```bash
npm run build:web
```
*(Comando eseguito: `flutter build web --release --base-href / --pwa-strategy=none`)*.

L'output viene generato nella cartella **`build/web`**.

---

## C. Come sincronizzare Capacitor

Dopo aver generato `build/web`, sincronizza gli asset web e la configurazione dentro il progetto nativo iOS (`ios/App`):

```bash
npm run cap:sync
# equivalente a: npx cap sync ios
```

Oppure, per eseguire **build web + sync Capacitor** con un solo comando:
```bash
npm run ios:prepare
```

> **Nota su Windows:** Durante `npx cap sync ios` su Windows comparirà l'avviso `[warn] Skipping pod install because CocoaPods is not installed`. È del tutto normale: `pod install` verrà eseguito automaticamente dal runner macOS su GitHub Actions.

---

## D. Come fare Commit e Push

Prima di ogni push, verifica sempre lo stato del repository e le differenze per assicurarti di non includere file indesiderati:

```bash
git status
git diff
```

Poi registra e invia le modifiche sul branch `ios`:
```bash
git add .
git commit -m "feat(ios): descrizione della modifica"
git push origin ios
```

---

## E. Come avviare GitHub Actions

Il workflow `.github/workflows/ios-build.yml` si avvia in **due modi**:

1. **Automaticamente (su Push):** Ogni volta che esegui `git push origin ios`.
2. **Manualmente (Workflow Dispatch):**
   - Vai su GitHub nella scheda **Actions** del repository (`https://github.com/Races30/Cubetrainer/actions`).
   - Seleziona a sinistra il workflow **"Build iOS Unsigned IPA"**.
   - Clicca su **"Run workflow"**, seleziona il branch **`ios`** e clicca sul pulsante verde **"Run workflow"**.

---

## F. Come controllare la Build

1. Apri la scheda **Actions** del repository:  
   `https://github.com/Races30/Cubetrainer/actions`
2. Clicca sull'esecuzione in corso (ha come titolo il messaggio del tuo ultimo commit).
3. Clicca sul job **"Build Unsigned IPA (macOS)"** per seguire in tempo reale tutti i 14 step (Checkout, Setup Node/Flutter, Test, Web Build, Capacitor Sync, Xcodebuild, Creazione IPA, Upload Artifact, Aggiornamento Release).
4. Al termine (circa 4–7 minuti), verifica che lo stato sia **Completed** con spunta verde (**Success**).

---

## G. Dove trovare l'IPA negli Artifact di GitHub Actions

Al termine di ogni run completata con successo:
1. Apri la pagina di riepilogo (**Summary**) della run in GitHub Actions.
2. Scorri in basso fino alla sezione **Artifacts**.
3. Scarica **`CubeTrainer-unsigned-ipa`** (archivio `.zip` che contiene `CubeTrainer-unsigned.ipa` e `BUILD_INFO.txt`).

---

## H. Dove trovare la GitHub Release (`latest-ios`)

Oltre che negli Artifact, ogni build aggiorna automaticamente la Release dedicata **`latest-ios`**:
1. Vai nella sezione **Releases** del repository GitHub:  
   `https://github.com/Races30/Cubetrainer/releases/tag/latest-ios`
2. Sotto **Assets** troverai direttamente scaricabili:
   - **`CubeTrainer-unsigned.ipa`** (pronto da scaricare direttamente su iPhone o PC/Mac per l'installazione tramite Sideloadly / AltStore / SideStore / TrollStore / ESign / Feather).
   - **`BUILD_INFO.txt`** (scheda tecnica con i dettagli del commit e della build).

---

## I. Come riconoscere quale Commit è dentro l'IPA

Puoi verificare in qualsiasi momento da quale commit proviene un file `CubeTrainer-unsigned.ipa` in **4 modi**:

1. **Dalla pagina della GitHub Release `latest-ios`:** Nel titolo e nel corpo della release sono indicati esplicitamente `Commit SHA`, `Branch`, `Versione App`, `Build Number` e `Data Build (UTC)`.
2. **Dal file `BUILD_INFO.txt`:** Allegato sia nella Release sia nell'Artifact accanto all'IPA.
3. **Dall'interno del file `.ipa` stesso:** Un file `.ipa` è un normale archivio ZIP. Se lo apri/estrai:
   - `Payload/App.app/BUILD_INFO.txt` contiene il riepilogo testuale completo.
   - `Payload/App.app/public/build-info.json` contiene il JSON con `commitSha`, `shortSha`, `branch`, `version`, `buildNumber` e `buildDateUtc`.
   - `Payload/App.app/Info.plist` contiene le chiavi `GitCommitSHA`, `GitCommitShortSHA`, `GitBranch`, `BuildDateUTC`, `CFBundleShortVersionString` e `CFBundleVersion`.
4. **Nel Riepilogo della Run (Step Summary) di GitHub Actions:** Nella tabella *CubeTrainer iOS Unsigned Build Summary*.

---

## J. Come aggiornare la Release `latest-ios`

Non serve alcuna operazione manuale per aggiornare `latest-ios`:
- Lo step 14 del workflow `.github/workflows/ios-build.yml` sposta automaticamente il tag `latest-ios` sul nuovo commit appena compilato, aggiorna le note di rilascio con il nuovo SHA e il changelog degli ultimi 5 commit, e sovrascrive (`--clobber`) il file `CubeTrainer-unsigned.ipa` senza creare release duplicate.
- Se vuoi incrementare il numero di versione dell'app (es. da `1.0.0` a `1.1.0`), aggiorna il campo `"version"` in `package.json` (e `version:` in `pubspec.yaml`) prima di fare commit e push.

---

## K. Cosa fare in caso di Errore

1. **Il workflow fallisce allo Step 6 (`Lint & Tests`):**
   - Esegui in locale `npm run lint` e `npm test` per vedere quale test o controllo fallisce, correggi il codice in `lib/` o `test/`, e fai un nuovo commit + push.
2. **Il workflow fallisce allo Step 7 (`Build Production Web App`):**
   - Esegui in locale `npm run build:web` per riprodurre l'errore di compilazione Dart/Flutter.
3. **Schermata bianca all'avvio dell'app su iOS:**
   - Verifica di aver compilato la web app usando `npm run build:web` (che imposta `--base-href /` e `--pwa-strategy=none`) e **non** con `--base-href /Cubetrainer/`.
4. **Il Coach AI risponde "Chiave API non configurata":**
   - Vai su GitHub in **Settings → Secrets and variables → Actions → New repository secret**, crea il secret **`DEEPSEEK_API_KEY`** con la tua chiave OpenRouter, e riavvia il workflow.

---

## L. Cosa NON modificare

Per non rompere la pipeline automatica iOS, **NON modificare**:
- **`webDir: "build/web"`** in `capacitor.config.json` (deve coincidere esattamente con la directory di output di `flutter build web`).
- Il flag **`--base-href /`** nello script `build:web` di `package.json` (dentro Capacitor l'app gira sulla root `/`).
- I parametri **`CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO`** in `.github/workflows/ios-build.yml` e nel blocco `post_install` di `ios/App/Podfile` (necessari per compilare su GitHub Actions senza certificati Apple a pagamento).
- La regola **`assets/.env`** in `.gitignore` (non committare mai chiavi API reali nel repository).
- Il branch **`main`** per modifiche specifiche di Capacitor/iOS (lavora sempre sul branch `ios`).
