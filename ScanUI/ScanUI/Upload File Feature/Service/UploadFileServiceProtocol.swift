//
//  UploadFileServiceProtocol.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation
import UniformTypeIdentifiers

public protocol UploadFileServiceProtocol: AnyObject {
    func getFileUTTypes() async -> [UTType]
    func startScan(atURL url: URL) async throws -> ScanResult
}
