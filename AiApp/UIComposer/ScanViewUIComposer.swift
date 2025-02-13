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

@MainActor
public final class DataScannerComposer {
    
    private init() {}
        
    public static func dataScanComposedWith(
        scanResult: @escaping (ScanResult) -> Void = { _ in }
    ) -> ScanView {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let scanStore = ScanStore()
                
        let scanPresenter = ScanPresenter(delegate: scanStore, resultOfScan: scanResult, bundle: bundle)
        
        return ScanView(store: scanStore, presenter: scanPresenter)
    }
}
