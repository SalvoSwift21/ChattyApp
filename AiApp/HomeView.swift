//
//  HomeView.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 16/02/24.
//

import SwiftUI

struct ContainerHomeView: View {
    
    @State private var presentedTextAnalyzer: [String] = []
    
    @State private var showUpload = false
    @State private var showScan = false
    
    var body: some View {
        NavigationStack(path: $presentedTextAnalyzer) {
            HomeUIComposer.homeComposedWith(client: .init(session: .init(configuration: .ephemeral)), upload: {
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
                TextAnalyzerComposer.textAnalyzerComposedWith(text: resultOfScan)
            }
        }
    }
}

#Preview {
    ContainerHomeView()
}
