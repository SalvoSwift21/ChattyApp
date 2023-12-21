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
    @State private var presented = false
    @State private var startScanning = true
    @State private var scanText = ""

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
                    HomeUIComposer.homeComposedWith(client: .init(session: .init(configuration: .ephemeral)), newScan: {
                        presented = true
                    })
                }
            }
            .environmentObject(appRootManager)
            .sheet(isPresented: $presented) {
                VStack(spacing: 0) {
                    DataScannerView(startScanning: $startScanning, scanText: $scanText)
                        .frame(height: 400)
                 
                    Text(scanText)
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
                        .background(in: Rectangle())
                        .backgroundStyle(Color(uiColor: .systemGray6))
                 
                }
                .task {
                    if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                        startScanning.toggle()
                    }
                }
            }
        }
    }
}
