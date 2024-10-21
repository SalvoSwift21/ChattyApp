//
//  MenuSection.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation

public struct MenuSection: Codable {
    var id: UUID = UUID()

    var title: String?
    var rows: [MenuRow]
    
    public init(title: String? = nil, rows: [MenuRow]) {
        self.title = title
        self.rows = rows
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case rows
    }
    
}
