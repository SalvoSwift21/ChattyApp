//
//  AiAppApp.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 25/05/23.
//

import SwiftUI
import RestApi
import ScanUI

@main
struct AiAppApp: App {

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
                    HomeUIComposer.homeComposedWith(client: .init(session: .init(configuration: .ephemeral)))
                }
            }
            .environmentObject(appRootManager)
        }
    }
}
