//
//  Scan.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 07/05/24.
//

import Foundation
import UIKit

public struct ScanProtocolResult: Hashable {
    public var stringResult: String
    public var scanDate: Date
    public var image: UIImage?
}

public protocol ScanProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    var resultOfScan: ((ScanProtocolResult) -> Void) { get set }
}