//
//  UploadFileServiceProtocol.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation

public protocol ScanDetailServiceProtocol: AnyObject {
    func getScan() async -> Scan
}
