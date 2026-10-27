import UIKit
import WebKit
import Capacitor

private final class IosHapticsHandler: NSObject, WKScriptMessageHandler {
    private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let notificationGenerator = UINotificationFeedbackGenerator()

    override init() {
        super.init()
        lightGenerator.prepare()
        mediumGenerator.prepare()
        heavyGenerator.prepare()
        selectionGenerator.prepare()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let style = (message.body as? String)?.lowercased() ?? "light"
        DispatchQueue.main.async {
            switch style {
            case "heavy":
                self.heavyGenerator.impactOccurred()
                self.heavyGenerator.prepare()
            case "medium":
                self.mediumGenerator.impactOccurred()
                self.mediumGenerator.prepare()
            case "selection":
                self.selectionGenerator.selectionChanged()
                self.selectionGenerator.prepare()
            case "success":
                self.notificationGenerator.notificationOccurred(.success)
            case "warning":
                self.notificationGenerator.notificationOccurred(.warning)
            case "error":
                self.notificationGenerator.notificationOccurred(.error)
            default:
                self.lightGenerator.impactOccurred()
                self.lightGenerator.prepare()
            }
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let hapticsHandler = IosHapticsHandler()
    private var didRegisterBridge = false

    private let deepNavyColor = UIColor(
        red: 15.0 / 255.0,
        green: 23.0 / 255.0,
        blue: 42.0 / 255.0,
        alpha: 1.0
    )

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.isIdleTimerDisabled = true

        window?.overrideUserInterfaceStyle = .dark
        window?.backgroundColor = deepNavyColor

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(syncSafeAreaInsets),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onCapViewDidAppear),
            name: Notification.Name(rawValue: "CapacitorViewDidAppear"),
            object: nil
        )

        DispatchQueue.main.async { [weak self] in
            self?.configureBridgeWebView()
        }

        return true
    }

    @objc private func onCapViewDidAppear() {
        configureBridgeWebView()
        syncSafeAreaInsets()
    }

    private func configureBridgeWebView() {
        window?.overrideUserInterfaceStyle = .dark
        window?.backgroundColor = deepNavyColor

        guard let capVC = window?.rootViewController as? CAPBridgeViewController,
              let webView = capVC.webView else {
            return
        }

        capVC.overrideUserInterfaceStyle = .dark
        capVC.setStatusBarStyle(.lightContent)

        webView.isOpaque = false
        webView.backgroundColor = deepNavyColor
        webView.scrollView.backgroundColor = deepNavyColor
        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceVertical = false
        webView.scrollView.alwaysBounceHorizontal = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsLinkPreview = false

        if !didRegisterBridge {
            didRegisterBridge = true
            webView.configuration.userContentController.removeScriptMessageHandler(forName: "iosHaptics")
            webView.configuration.userContentController.add(hapticsHandler, name: "iosHaptics")
        }

        syncSafeAreaInsets()
    }

    @objc private func syncSafeAreaInsets() {
        guard let win = window,
              let capVC = win.rootViewController as? CAPBridgeViewController,
              let webView = capVC.webView else {
            return
        }

        let insets = win.safeAreaInsets
        let js = """
        window.__nativeSafeAreaInsets = {
          top: \(insets.top),
          bottom: \(insets.bottom),
          left: \(insets.left),
          right: \(insets.right)
        };
        window.dispatchEvent(new CustomEvent('ios-safe-area-change'));
        """
        webView.evaluateJavaScript(js, completionHandler: nil)
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        application.isIdleTimerDisabled = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        application.isIdleTimerDisabled = true
        syncSafeAreaInsets()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        application.isIdleTimerDisabled = true
        configureBridgeWebView()
        syncSafeAreaInsets()
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ApplicationDelegateProxy.shared.application(app, open: url, options: options)
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return ApplicationDelegateProxy.shared.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
}
