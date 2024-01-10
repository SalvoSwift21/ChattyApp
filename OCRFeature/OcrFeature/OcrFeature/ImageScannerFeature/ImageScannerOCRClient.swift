//
//  ImageScannerOCRClient.swift
//  OCRFeature
//
//  Created by Salvatore Milazzo on 08/01/24.
//

import Foundation
import VisionKit
import Vision
import OSLog

public final class ImageScannerOCRClient {
    
    private var delegate: ConcrateOCRClientDelegate
    
    private lazy var logger = Logger(subsystem: "com.ariel.one.OCRFeature", category: "ImageScannerOCRClient")
    
    public init(delegate: ConcrateOCRClientDelegate) {
        self.delegate = delegate
    }
}

extension ImageScannerOCRClient: OCRClient {
    
    public typealias OCRClientRequest = URL
    public typealias OCRClientResponse = Swift.Result<String, Error>
    
    public func makeRequest(object: URL) throws {
        
        let file = try Data(contentsOf: object)
        guard let image = UIImage(data: file as Data) else { return }
        
        // Get the CGImage on which to perform requests.
        guard let cgImage = image.cgImage else { return }


        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)


        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)


        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    fileprivate func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        let recognizedStrings = observations.map({ observation in
            return observation.topCandidates(1).first
        })
        .map({ $0?.string })
        .compactMap({ $0 })
        .joined(separator: " \n")
        
        // Process the recognized strings.
        self.delegate.recognizedItemCompletion?(recognizedStrings)
    }
}