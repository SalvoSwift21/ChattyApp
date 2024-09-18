//
//  Service.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation

public class ScanDetailService: ScanDetailServiceProtocol {
    
    private var scan: Scan
    
    public init(scan: Scan) {
        self.scan = scan
    }
    
    public func getScan() async -> Scan {
        return scan
    }
}
