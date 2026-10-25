# Istruzioni Installazione Widget iOS (home_widget)

Dato che l'ambiente Flutter tramite CLI non può modificare i file di progetto Xcode (`.pbxproj`) automaticamente in maniera sicura senza script Ruby pazzeschi (es. CocoaPods o Xcodeproj), dovrai eseguire questi comandi/task manuali per far funzionare il widget iOS.

## 1. Aprire Xcode

Apri `ios/Runner.xcworkspace` tramite Xcode.

## 2. Aggiungere il Widget Target

1. In Xcode, vai su **File > New > Target...**
2. Scegli **Widget Extension** e clicca Next.
3. Chiamalo `StatsWidget` e **deseleziona** "Include Configuration Intent". Clicca Finish.
4. Sostituisci il contenuto del file generato `StatsWidget.swift` con il contenuto del file già creato da me in `ios/StatsWidget/StatsWidget.swift`.

## 3. Configurare gli App Groups

Il plugin `home_widget` usa gli App Groups per poter scambiare dati (UserDefaults) in background tra l'app Flutter e il Widget iOS (che sono sandbox separati).

1. Nel progetto Xcode, clicca sul **Runner** target -> **Signing & Capabilities**.
2. Clicca il **+ Capability** e aggiungi **App Groups**.
3. Aggiungi il gruppo `group.com.example.cubetrainer` (sostituisci con il tuo BundleID effettivo).
4. Fai ESATTAMENTE la stessa cosa per il target **StatsWidget**: Signing & Capabilities -> + Capability -> App Groups -> seleziona lo stesso identico nome del gruppo (`group.com.example.cubetrainer`).

## 4. Test

Compila e lancia l'app da Xcode su un device o emulatore. Vai in background e aggiungi il widget alla tua home. Quando esegui una nuova Solve dal Timer (che invoca `HomeWidgetHelper.updateWidgetInfo()`), vedrai il widget di Xcode aggiornarsi automaticamente.
