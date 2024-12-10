//
//  Service.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation
import OCRFeature
import UniformTypeIdentifiers

public class UploadFileService: UploadFileServiceProtocol {
    
    let imageScannerOCRClient: ImageScannerOCRClient
    
    public init(imageScannerOCRClient: ImageScannerOCRClient) {
        self.imageScannerOCRClient = imageScannerOCRClient
    }
   
    public func getFileUTTypes() async -> [UTType] {
        return [.image, .png, .jpeg, .pdf, .text, .plainText, .html, .rtf]
    }
    
    public func startScan(atURL url: URL) async throws {
        try imageScannerOCRClient.makeRequest(object: url)
    }
}
