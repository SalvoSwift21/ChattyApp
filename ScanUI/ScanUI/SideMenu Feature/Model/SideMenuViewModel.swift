//
//  SideMenuViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation
import UIKit

public struct SideMenuViewModel {
    
    var sections: [MenuSection] = []
    var topImage: UIImage? = nil
    
    public init(sections: [MenuSection], topImage: UIImage? = nil) {
        self.sections = sections
        self.topImage = topImage
    }
}
