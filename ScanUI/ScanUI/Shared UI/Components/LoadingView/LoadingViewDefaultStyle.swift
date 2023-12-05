//
//  LoadingViewDefaultStyle.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 05/12/23.
//

import Foundation
import SwiftUI

struct LoadingViewDefaultStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .trim(from: 0.1, to: 1.0)
                .stroke(.prime, lineWidth: 3)
                .frame(width: 30, height: 30)
                .rotationEffect(.degrees(configuration.fractionCompleted == 1.0 ? 360 : 0))
        }
    }
}
