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

public final class ScanViewUIComposer {
    private init() {}
        
    @MainActor public static func scanComposedWith() throws -> DataScannerViewController? {
        let documentView = DataScannerOCRClient<String>(delegate: Delegato())
        try documentView.makeRequest(object: [.text()])
        
        return documentView.dataScannerViewController
    }
}

public final class Delegato: OCRClientDelegate {
    
    init() { }
    
    public func recognizedItem<OCRClientResponse>(response: OCRClientResponse) {
        print(response as? String)
    }
}


import SwiftUI

struct MyDataScannerViewControllerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = DataScannerViewController
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        do {
            let result = try ScanViewUIComposer.scanComposedWith()
            return result ?? DataScannerViewController()
        } catch {
            print("Error \(error.localizedDescription)")
            return DataScannerViewController()
        }
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }

}
