//
//  Scan.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 07/05/24.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

public struct ScanResult: Hashable {
    public var stringResult: String
    public var scanDate: Date
    public var fileData: Data?
    public var fileType: String?
    
    public func getFileUTType() -> UTType? {
        guard let fileType else { return nil }
        return UTType(fileType)
    }
}

public protocol ScanProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    var resultOfScan: ((ScanResult) -> Void) { get set }
}
