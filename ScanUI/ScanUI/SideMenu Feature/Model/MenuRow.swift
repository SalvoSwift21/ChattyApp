//
//  MenuRow.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation
import UIKit

public struct MenuRow: Codable {
    var id: UUID = UUID()
    
    var title: String
    var imageName: String
    public var rowType: SideMenuRowType
    
    public init(title: String, imageName: String, rowType: SideMenuRowType) {
        self.title = title
        self.imageName = imageName
        self.rowType = rowType
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case imageName
        case rowType
    }
}

public enum SideMenuRowType: String, CaseIterable, Codable {
    case home
    case premium
    case chooseAi
    case rateUs
    case help
    case termsAndConditions
    case privacyPolicy
}
