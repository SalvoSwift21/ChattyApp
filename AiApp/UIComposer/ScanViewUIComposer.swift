//
//  ScanViewUIComposer.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 19/12/23.
//

import Foundation
import OCRFeature
import ScanUI
import VisionKit
import SwiftUI

struct DataScannerView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = DataScannerViewController
    
    @Binding var startScanning: Bool
    @Binding var scanText: String
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let dataScannerClient = DataScannerOCRClient<String>(delegate: context.coordinator)
        context.coordinator.dataScannerClient = dataScannerClient
        return dataScannerClient.dataScannerViewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if startScanning {
            try? context.coordinator.dataScannerClient?.makeRequest(object: [.text()])
        } else {
            //context.coordinator.dataScannerClient?.dataScannerViewController.stopScanning()
        }
    }
    
    class Coordinator: NSObject, OCRClientDelegate {
        
        var parent: DataScannerView
        var dataScannerClient: DataScannerOCRClient<String>?
        
        init(_ parent: DataScannerView) {
            self.parent = parent
        }
        
        func recognizedItem<OCRClientResponse>(response: OCRClientResponse) {
            print("Response \(response)")
            parent.scanText = response as? String ?? "Not a correct string"
        }
    }
     
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}


