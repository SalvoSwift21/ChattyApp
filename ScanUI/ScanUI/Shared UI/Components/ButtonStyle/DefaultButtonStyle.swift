//
//  DefaultButtonStyle.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 04/12/23.
//

import Foundation
import SwiftUI

struct DefaultButtonStyle: ButtonStyle {
    var frame: CGSize
    var backgroundColor: Color = .prime
    var foregroundStyle: Color = .buttonTitle
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: frame.width, height: frame.height, alignment: .center)
            .background(backgroundColor)
            .foregroundStyle(foregroundStyle)
            .clipShape(Capsule())
    }
}
