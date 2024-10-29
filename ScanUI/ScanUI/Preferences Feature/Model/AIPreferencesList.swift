//
//  AIPreferencesList.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 22/10/24.
//

import Foundation

public struct AIPreferencesList: Codable {
    var id: UUID = UUID()

    public var avaibleAI: [AIPreferenceModel]
    
    public init(avaibleAI: [AIPreferenceModel]) {
        self.avaibleAI = avaibleAI
    }
    
    enum CodingKeys: String, CodingKey {
        case avaibleAI
    }
    
}
