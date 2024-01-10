//
//  ScanProtocols.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import Foundation

public protocol ScanProtocols: AnyObject {
    var resourceBundle: Bundle { get set }
    var resultOfScan: ((String) -> Void) { get set }
    
    func startScan()
    func stopScan()
}

public protocol ScanProtocolsDelegate: AnyObject {
    func render(errorMessage: String)
    func renderLoading(visible: Bool)
    func render(viewModel: ScanViewModel)
}
