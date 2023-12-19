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
    func recognizedItem<OCRClientResponse>(response: OCRClientResponse)
}
