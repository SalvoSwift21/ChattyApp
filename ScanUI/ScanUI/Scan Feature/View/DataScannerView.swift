//
//  DataScannerView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 11/01/24.
//

import Foundation
import VisionKit
import SwiftUI

struct DataScannerView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = DataScannerViewController
    
    var dataScannerViewController: DataScannerViewController
        
    func makeUIViewController(context: Context) -> DataScannerViewController {
        return dataScannerViewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) { }
    
    class Coordinator: NSObject {
        
        var parent: DataScannerView
        
        init(_ parent: DataScannerView) {
            self.parent = parent
        }
    }
     
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}


