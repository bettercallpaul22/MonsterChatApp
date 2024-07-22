//
//  MonsterChatApp.swift
//  MonsterChat
//
//  Created by Obaro Paul on 04/06/2024.
//


import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}




@main
struct MonsterChatApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        
        WindowGroup {
         ContentView()
                .onChange(of: scenePhase) { _, newScenePhase in
                                    if newScenePhase == .background {
                                        print("app exit")
                                    }
                                }
            }
        }
        
    }

