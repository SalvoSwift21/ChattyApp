//
//  Extensions+Date.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 17/06/24.
//

import Foundation

extension Date {
    
    func recentScanMode() -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateStyle = .short
        dateFormatterPrint.timeStyle = .short
        
        return dateFormatterPrint.string(from: self)
    }
    
}
