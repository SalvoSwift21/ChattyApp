//
//  ScanServiceProtocol.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import Foundation

public protocol ScanServiceProtocol: AnyObject {
    func startDataScanner() throws
    func stopDataScanner() throws
    
    func handleTappingItem(text: String) async

}
