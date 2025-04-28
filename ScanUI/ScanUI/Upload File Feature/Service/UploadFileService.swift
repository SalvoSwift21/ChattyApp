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
    
    enum UploadFileServiceError: Error {
        case invalidFileType
    }
    
    let imageScannerOCRClient: ImageScannerOCRClient
    let UTTypes: [UTType]
    private var ocrConcreteDelegate = ImageScannerOCRClientDelegate()
    
    public init(UTTypes: [UTType]) {
        self.imageScannerOCRClient = ImageScannerOCRClient(delegate: ocrConcreteDelegate)
        self.UTTypes = UTTypes
    }
   
    public func getFileUTTypes() async -> [UTType] {
        return UTTypes
    }
    
    public func startScan(atURL url: URL) async throws -> ScanResult {
        guard let fileType = url.mimeType() else {
            throw UploadFileServiceError.invalidFileType
        }
        
        switch fileType {
        case .image, .jpeg, .png:
            return try await extractScanFromImage(url)
        default: return try extractDataFromFiles(url)
        }
    }
}

//MARK: Logic for Image
fileprivate extension UploadFileService {
    
    func extractScanFromImage(_ url: URL) async throws -> ScanResult {
        return try await withCheckedThrowingContinuation { continuation in
            self.ocrConcreteDelegate.recognizedItemCompletion = { scanResult in
                let result = ScanResult(stringResult: scanResult.0, scanDate: Date(), fileData: scanResult.1?.pngData(), fileType: url.mimeType()?.identifier)
                continuation.resume(returning: result)
            }
            
            self.ocrConcreteDelegate.errorOnScanning = { error in
                continuation.resume(throwing: error)
            }
            
            do {
                try imageScannerOCRClient.makeRequest(object: url)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
}

//MARK: Logic for PDF
fileprivate extension UploadFileService {
    
    func extractDataFromFiles(_ url: URL) throws -> ScanResult {
        let data = try Data(contentsOf: url)
        return ScanResult(stringResult: "", scanDate: Date(), fileData: data, fileType: url.mimeType()?.identifier)
    }
    
}
