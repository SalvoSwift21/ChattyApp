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

public class AppConfiguration {
    
    static public var shared = AppConfiguration()
    
    static let appGroupName = "group.com.ariel.ai.scan.app"
    
    let preferencesStoreManager = UserDefaults(suiteName: "PREFERENCES_STORE_MANAGER")
    
    var storeURL: URL = {
        guard var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppConfiguration.appGroupName) else {
            return URL(string: "Test")!
        }
        let storeURLResult = storeURL.appendingPathComponent("AI.SCAN.sqlite")
        return storeURLResult
    }()
    
    var preferenceService: LocalAIPreferencesService
    
    private(set) var currentSelectedAI: AIPreferenceType = .unowned
    
    private init() { 
        preferenceService = LocalAIPreferencesService(resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main, userDefault: preferencesStoreManager ?? .standard)
    }
    
    public func bootApp() async {
        await selectAIIfNeeded()
    }
    
    public func updatePreferences() {
        Task {
            guard let result = try? await preferenceService.loadAIPreferencereType() else { return }
            self.updateAI(with: result)
        }
    }
    
    
    fileprivate func updateAI(with newAI: AIPreferenceType) {
        self.currentSelectedAI = newAI
    }
    
    fileprivate func selectAIIfNeeded() async {
        do {
            let allAI = try await preferenceService.getAIPreferences()
            
            guard let defaultAI = allAI.avaibleAI.first else {
                fatalError("No AI Avaible")
            }
            
            let result = try? await preferenceService.loadAIPreferencereType()
            
            guard let result = result else {
                try await preferenceService.saveAIPreferencereType(defaultAI)
                self.updateAI(with: defaultAI.aiType)
                return
            }
            
            self.updateAI(with: result)
            
        } catch {
            fatalError("No AI Avaible")
        }
    }
}

@main
struct AiAppApp: App {
    
    @StateObject private var appRootManager = AppRootManager()
    
    @MainActor
    private func getStorage() -> ScanStorege {
        let url = AppConfiguration.shared.storeURL
        do {
            return try SwiftDataStore(storeURL: url)
        } catch {
            return try! SwiftDataStore(storeURL: URL(string: "Fatal ERROR")!)
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
