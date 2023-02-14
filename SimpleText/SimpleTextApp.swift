//
//  SimpleTextApp.swift
//  SimpleText
//
//  Created by Max094_Reikeb on 19/09/2022.
//
// TODO: Choses à rajouter
// - Permettre une sauvegarde pour ne pas perdre les données lors de la fermeture de l'app
// - Historique + mode "incognito"
// - Exporter en PDF
// - Mode multi-fenêtres
// - Plus d'options de mise en forme
// - Personaliser le fond de l'app (thèmes)
// - Widgets
// - Live Activity
//

import SwiftUI

@main
struct SimpleTextApp: App {

    // @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    // @Environment(\.scenePhase) private var scenePhase
    @StateObject var datasManager = DataManager()

    var newText = TextView(text: .constant(""), textSize: .constant(20.0))

    var body: some Scene {
        WindowGroup {
            ContentView(textSize: 20.0, newText: newText, loadData: true)
                .environmentObject(datasManager)
                /*.onAppear {
                    // appDelegate.onTerminate = {
                    //     saveDatas()
                    // }
                    DataManager.load { result in
                        switch result {
                        case.success(let success):
                            datasManager.data = success
                            newText.text = datasManager.data.first?.savedText ?? ""
                        case .failure(let failure):
                            fatalError(failure.localizedDescription)
                        }
                    }
                }*/
        }
        // .onChange(of: scenePhase) { phase in
        //     if phase == .background {
        //         saveDatas()
        //     }
        // }
    }

    /*
    func saveDatas() {
        let newDatas = Data(savedText: newText.text)
        var data = datasManager.data
        if !data.isEmpty { data.removeFirst() }
        data.append(newDatas)
        DataManager.save(datas: data) { result in
            if case .failure(let failure) = result {
                fatalError(failure.localizedDescription)
            }
        }
    }*/
}

/*
class AppDelegate: NSObject, UIApplicationDelegate {
    var onTerminate: (() -> Void)?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        onTerminate?()
    }
}

public extension UIApplication {

    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }

        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window
    }
}
*/
