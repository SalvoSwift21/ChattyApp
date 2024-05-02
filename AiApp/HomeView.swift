//
//  HomeView.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 16/02/24.
//

import SwiftUI
import ScanUI

struct ContainerHomeView: View {
    
    @State private var scanStorage: ScanStorege
    
    @State private var presentedTextAnalyzer: [String] = []
    
    @State private var showUpload = false
    @State private var showScan = false
    
    init(storage: ScanStorege) {
        self.scanStorage = storage
    }
    
    var body: some View {
        NavigationStack(path: $presentedTextAnalyzer) {
            HomeUIComposer.homeComposedWith(client: scanStorage, upload: {
                showUpload.toggle()
            }, newScan: {
                showScan.toggle()
            })
            .navigationDestination(isPresented: $showScan, destination: {
                DataScannerComposer.uploadFileComposedWith { resultOfScan in
                    presentedTextAnalyzer.append(resultOfScan)
                }
            })
            .navigationDestination(isPresented: $showUpload, destination: {
                UploadFileComposer.uploadFileComposedWith { resultOfScan in
                    presentedTextAnalyzer.append(resultOfScan)
                }
            })
            .navigationDestination(for: String.self) { resultOfScan in
                TextAnalyzerComposer.textAnalyzerComposedWith(text: resultOfScan, scanStorage: scanStorage)
            }
        }
    }
}

//#Preview {
//    let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
//    let swiftDataStore = try! SwiftDataStore(storeURL: url)
//    HStack {
//        ContainerHomeView(storage: swiftDataStore)
//    }
//}
