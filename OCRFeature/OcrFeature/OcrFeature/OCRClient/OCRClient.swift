//
//  OCRClient.swift
//  OCRFeature
//
//  Created by Salvatore Milazzo on 18/12/23.
//

import Foundation

public protocol OCRClient {
    
    associatedtype OCRClientRequest
    
    func makeRequest(object: OCRClientRequest) throws 
}


public protocol OCRClientDelegate {
    
    associatedtype OCRClientRecognizeItems
    associatedtype OCRClientResponse
    
    var recognizedItemCompletion: ((OCRClientResponse) -> Void)? { get set }
    var didRecognizeItems: ((OCRClientRecognizeItems) -> Void)? { get set }

    var errorOnScanning: ((Error) -> Void)? { get set }
}
