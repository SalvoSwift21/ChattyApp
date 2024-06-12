//
//  ScanProtocols.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import Foundation

public protocol ScanProtocols: ScanProtocol {
    func startScan()
    func stopScan()
}

public protocol ScanProtocolsDelegate: AnyObject {
    func render(errorMessage: String)
    func renderLoading(visible: Bool)
    func render(viewModel: ScanViewModel)
}
