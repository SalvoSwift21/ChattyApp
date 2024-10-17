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
    
    var storeURL: URL = {
        guard var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppConfiguration.appGroupName) else {
            return URL(string: "Test")!
        }
        let storeURLResult = storeURL.appendingPathComponent("AI.SCAN.sqlite")
        return storeURLResult
    }()
    
    private init() { }
}

@main
struct AiAppApp: App {
    
    @State private var scanText = ""
    @State private var showingAlert = false
    @State private var showTextAnalyzer = false

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
        }
    }
}
