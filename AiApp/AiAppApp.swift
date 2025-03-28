//
//  AiAppApp.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 25/05/23.
//

import SwiftUI
import RestApi
import ScanUI
import VisionKit
import LLMFeature
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct AiAppApp: App {
    
    @StateObject private var appRootManager = AppRootManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .onboarding:
                    OnboardingUIComposer.onboardingComposedWith {
                        withAnimation(.ripple()) {
                            appRootManager.currentRoot = .mainContainer
                        }
                    }
                case .mainContainer:
                    MainContainerView(storage: AppConfiguration.shared.dataConfigurationManager.storage)
                default:
                    EmptyView()
                }
            }
            .environmentObject(appRootManager)
            .environment(AppConfiguration.shared.purchaseManager)
            .environment(AppConfiguration.shared.dataConfigurationManager.changeManager)
            .task {
                await bootApp()
            }
            .task {
                await AppConfiguration.shared.bootSecondaryService()
            }
        }
    }
    
    fileprivate func bootApp() async {
        do {
            try await AppConfiguration.shared.bootApp()
        } catch {
            fatalError("App not load correctly: \(error)")
        }
    }
}
