//
//  Extensions+Text.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 03/12/24.
//

import SwiftUI

extension Text {
    init(_ key: String, bundle: Bundle) {
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
        self.init(localizedString)
    }
}
