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
                    HomeUIComposer.homeComposedWith(client: .init(session: .init(configuration: .ephemeral)), upload: {
                        appRootManager.currentRoot = .upload
                    }, newScan: {
                        appRootManager.currentRoot = .scan
                    })
                case .upload:
                    UploadFileComposer.uploadFileComposedWith { resultOfScan in
                        scanText = resultOfScan
                        showingAlert = true
                    }.alert("Risultato della scansione \(scanText)", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) {
                            scanText = ""
                            appRootManager.currentRoot = .home
                        }
                    }
                case .scan:
                    DataScannerComposer.uploadFileComposedWith { resultOfScan in
                        scanText = resultOfScan
                        showingAlert = true
                    }.alert("Risultato della scansione \(scanText)", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) {
                            scanText = ""
                            appRootManager.currentRoot = .home
                        }
                    }
                }
            }
            .environmentObject(appRootManager)
        }
    }
}
