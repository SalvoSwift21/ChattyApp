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

@main
struct AiAppApp: App {
    
    @State private var scanText = ""
    @State private var showingAlert = false
    @State private var showTextAnalyzer = false

    @StateObject private var appRootManager = AppRootManager()

    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .onboarding:
                    OnboardingUIComposer.onboardingComposedWith {
                        withAnimation(.ripple()) {
                            appRootManager.currentRoot = .home
                        }
                    }
                case .home:
                    ContainerHomeView()
                default:
                    Text("Empty state")
                }
            }
            .environmentObject(appRootManager)
        }
    }
}
