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

@main
struct AiAppApp: App {
    
    @StateObject private var appRootManager = AppRootManager()
    
    @MainActor
    private func getStorage() -> ScanStorege {
        let url = AppConfiguration.shared.storeURL
        do {
            return try SwiftDataStore(storeURL: url, defaultFolderName: AppConfiguration.defaultFolderName)
        } catch {
            return try! SwiftDataStore(storeURL: URL(string: "Fatal ERROR")!, defaultFolderName: AppConfiguration.defaultFolderName)
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
                    MainContainerView(storage: getStorage())
                default:
                    Text("Empty state")
                }
            }
            .environmentObject(appRootManager)
            .task {
                await AppConfiguration.shared.bootApp()
            }
        }
    }
}
