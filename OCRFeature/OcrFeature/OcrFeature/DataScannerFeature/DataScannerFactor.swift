//
//  DataScannerFactor.swift
//  OCRFeature
//
//  Created by Salvatore Milazzo on 22/12/23.
//

import Foundation
import VisionKit


final class DataScannerFactor {
    private init() {}
        
    @MainActor
    public static func makeDataScanner(recognizedDataType: Set<DataScannerViewController.RecognizedDataType>) -> DataScannerViewController {
        return DataScannerViewController(recognizedDataTypes: recognizedDataType,
                                         qualityLevel: .accurate,
                                         recognizesMultipleItems: false,
                                         isHighFrameRateTrackingEnabled: false,
                                         isPinchToZoomEnabled: false,
                                         isGuidanceEnabled: false,
                                         isHighlightingEnabled: true)
    }
}
