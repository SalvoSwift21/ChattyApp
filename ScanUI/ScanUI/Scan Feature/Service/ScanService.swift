//
//  ScanService.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import Foundation
import OCRFeature

public class ScanService: ScanServiceProtocol {
    
    
    let dataScannerOCRClient: DataScannerOCRClient
    
    public init(dataScannerOCRClient: DataScannerOCRClient) {
        self.dataScannerOCRClient = dataScannerOCRClient
    }
   
    @MainActor public func startDataScanner() throws {
        try dataScannerOCRClient.makeRequest(object: true)
    }
    
    @MainActor public func stopDataScanner() throws {
        try dataScannerOCRClient.makeRequest(object: false)
    }
}
