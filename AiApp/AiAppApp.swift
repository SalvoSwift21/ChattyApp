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

@main
struct AiAppApp: App {
    
    @StateObject private var appRootManager = AppRootManager()
    
    @MainActor
    private var storage: ScanStorege {
        let url = AppConfiguration.shared.storeURL
        do {
            let dataStore = try SwiftDataStore(storeURL: url, defaultFolderName: AppConfiguration.defaultFolderName, changeManager: AppConfiguration.shared.changeManager)
            return dataStore
        } catch {
            return try! SwiftDataStore(storeURL: URL(string: "Fatal ERROR")!, defaultFolderName: AppConfiguration.defaultFolderName, changeManager: AppConfiguration.shared.changeManager)
        }
    }

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
                    MainContainerView(storage: storage)
                default:
                    EmptyView()
                }
            }
            .environmentObject(appRootManager)
            .environment(AppConfiguration.shared.purchaseManager)
            .environment(AppConfiguration.shared.changeManager)
            .task {
                await bootApp()
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
