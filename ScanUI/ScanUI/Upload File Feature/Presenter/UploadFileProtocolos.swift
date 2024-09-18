//
//  UploadFileProtocolos.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation

public protocol UploadFileProtocols: ScanProtocol {
    func startScan(atURL url: URL) async throws
    @Sendable func loadFilesType() async
}

public protocol UploadFileProtocolsDelegate: AnyObject {
    func render(errorMessage: String)
    func render(viewModel: UploadFileViewModel)
}
