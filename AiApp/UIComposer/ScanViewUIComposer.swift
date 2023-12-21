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

public final class DataScannerUIComposer {
    private init() {}
        
    @MainActor 
    public static func dataScannerComposeWith() -> (dataScannerOCRClient: DataScannerOCRClient, delegate: ConcrateOCRClientDelegate) {
        let delegate = ConcrateOCRClientDelegate()
        return (DataScannerOCRClient(delegate: delegate, recognizedDataType: [.text()]), delegate)
    }
}

struct DataScannerView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = DataScannerViewController
    
    @Binding var startScanning: Bool
    @Binding var scanText: String
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let dataScannerClient = DataScannerUIComposer.dataScannerComposeWith()
        context.coordinator.dataScannerClient = dataScannerClient
        context.coordinator.setCompletion()
        return dataScannerClient.dataScannerOCRClient.getCurrentDataScannerController()
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if startScanning {
            try? context.coordinator.dataScannerClient?.dataScannerOCRClient.makeRequest(object: true)
        } else {
           // try? context.coordinator.dataScannerClient?.dataScannerOCRClient.makeRequest(object: false)
        }
    }
    
    class Coordinator: NSObject {
        
        var parent: DataScannerView
        var dataScannerClient: (dataScannerOCRClient: DataScannerOCRClient, delegate: ConcrateOCRClientDelegate)?
        
        init(_ parent: DataScannerView) {
            self.parent = parent
        }
        
        func setCompletion() {
            dataScannerClient?.delegate.errorOnScanning = { error in
                print("Error")
            }
            
            dataScannerClient?.delegate.recognizedItemCompletion = { [weak self] text in
                self?.parent.scanText = text
            }
        }
    }
     
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}


