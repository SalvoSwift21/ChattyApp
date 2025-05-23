//
//  DataScannerOCRClient.swift
//  OCRFeature
//
//  Created by Salvatore Milazzo on 18/12/23.
//

import Foundation
import VisionKit
import OSLog


@MainActor
public final class DataScannerOCRClient {
    
    private var delegate: DataScannerOCRClientDelegate
    
    private lazy var logger = Logger(subsystem: "com.ariel.one.OCRFeature", category: "DataScanner")
    
    private var scannerAvailable: Bool {
        DataScannerViewController.isSupported &&
        DataScannerViewController.isAvailable
    }
    
    private var dataScannerViewController: DataScannerViewController
    private var allItems: [RecognizedItem] = []
    
    public init(delegate: DataScannerOCRClientDelegate, recognizedDataType: Set<DataScannerViewController.RecognizedDataType>) {
        self.delegate = delegate
        self.dataScannerViewController = DataScannerFactor.makeDataScanner(recognizedDataType: recognizedDataType)
        self.setDelegate()
        logger.debug("Data scanner is created: \(self.dataScannerViewController)")
        logger.debug("Data scanner delegate is: \(self.dataScannerViewController.delegate == nil)")
    }
    
    public func handleTappingItem(text: String) async {
        let currentImage = await self.makePhoto()
        self.delegate.recognizedItemCompletion?((text, currentImage))
    }
}

extension DataScannerOCRClient: @preconcurrency OCRClient {
    
    public typealias OCRClientRequest = Bool
    public typealias OCRClientResponse = Swift.Result<String, Error>
    
    public func makeRequest(object: Bool) throws {
        if object {
            try self.dataScannerViewController.startScanning()
        } else {
            self.dataScannerViewController.stopScanning()
        }
    }
    
    fileprivate func setDelegate() {
        self.dataScannerViewController.delegate = self
    }
}

extension DataScannerOCRClient: DataScannerViewControllerDelegate {
    
    //MARK: Customizing highlighting
    
    public func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        self.allItems = allItems
        self.delegate.didRecognizeItems?(allItems)
    }
    
    public func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        self.allItems = allItems
        self.delegate.didRecognizeItems?(allItems)
    }
    
    public func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        self.allItems = allItems
        self.delegate.didRecognizeItems?(allItems)
    }
    
    //MARK: Zooming
    
    public func dataScannerDidZoom(_ dataScanner: DataScannerViewController) {
        print("Zoom")
    }
    
    //MARK: Handling errors
    
    public func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
        logger.debug("Data scanner go in error with: \(error.localizedDescription)")
        self.delegate.errorOnScanning?(error)
    }
}


//MARK: Helpers

extension DataScannerOCRClient {
    
    public func isScannerAvaible() -> Bool {
        return self.scannerAvailable
    }
    
    public func getCurrentDataScannerController() -> DataScannerViewController {
        return self.dataScannerViewController
    }
    
    //MARK: -------------- HERE ONLY FOR REMEMBER NOT USED -----------
    fileprivate func updateViaAsyncStream() async {
        let scanner = dataScannerViewController
        let stream = scanner.recognizedItems
        for await newItems: [RecognizedItem] in stream {
            let diff = newItems.difference(from: allItems) { a, b in
                return a.id == b.id
            }
            if !diff.isEmpty {
                allItems = newItems
            }
        }
    }
    
    fileprivate func makePhoto() async -> UIImage? {
        return try? await dataScannerViewController.capturePhoto()
    }
}
