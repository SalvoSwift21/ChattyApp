//
//  DataScannerOCRClient.swift
//  OCRFeature
//
//  Created by Salvatore Milazzo on 18/12/23.
//

import Foundation
import Vision
import VisionKit

@MainActor
public final class DataScannerOCRClient<Result> {
    
    private var delegate: OCRClientDelegate
    
    var scannerAvailable: Bool {
        DataScannerViewController.isSupported &&
        DataScannerViewController.isAvailable
    }
    
    public var dataScannerViewController: DataScannerViewController?
    
    private var allItems: [RecognizedItem] = []
    private var completion: ((String) -> Void)?
    private var languages: [String] = []
    
    public init(delegate: any OCRClientDelegate) {
        self.delegate = delegate
    }
}

extension DataScannerOCRClient: DataScannerViewControllerDelegate {
    
    //MARK: Customizing highlighting
    
    public func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        print("addedItems")
        self.allItems = allItems
    }
    
    public func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        print("removedItems")
        self.allItems = allItems
    }
    
    public func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        print("Updateeee")
        self.allItems = allItems
    }
    
    
    //MARK: Zooming
    
    public func dataScannerDidZoom(_ dataScanner: DataScannerViewController) {
        print("Zoom")
    }
    
    //MARK: Tapping items
    
    public func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        switch item {
        case .text(let text):
            // Copy the text to the pasteboard.
            self.delegate.recognizedItem(response: text.transcript)
            dataScanner.stopScanning()
        case .barcode(let code):
            // Open the URL in the browser.
            break
        default: break
            // Insert code to handle other data types.
        }
    }
    
    //MARK: Handling errors
    
    public func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
        print("Data scanner error")
    }
}

extension DataScannerOCRClient: OCRClient {
    
    public typealias OCRClientRequest = Set<DataScannerViewController.RecognizedDataType>
    public typealias OCRClientResponse = Swift.Result<String, Error>
    
    public func makeRequest(object: Set<DataScannerViewController.RecognizedDataType>) throws {
        self.makeDataScannerViewController(recognizedDataTypes: object)
        try self.dataScannerViewController?.startScanning()
    }
    
    
    private func makeDataScannerViewController(recognizedDataTypes: Set<DataScannerViewController.RecognizedDataType>) {
        self.dataScannerViewController = DataScannerViewController(recognizedDataTypes: [.text()],
                                                                   qualityLevel: .balanced,
                                                                   recognizesMultipleItems: true,
                                                                   isHighFrameRateTrackingEnabled: true,
                                                                   isPinchToZoomEnabled: false,
                                                                   isGuidanceEnabled: true,
                                                                   isHighlightingEnabled: true)
        self.dataScannerViewController?.delegate = self
    }
}


