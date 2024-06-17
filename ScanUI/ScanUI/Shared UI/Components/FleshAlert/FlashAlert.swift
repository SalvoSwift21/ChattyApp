//
//  FlashAlert.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 17/06/24.
//

import SwiftUI

struct FlashAlert: View {
    
    var title: String
    var image: Image
    
    var body: some View {
        VStack {
            Text(title)
            image
                .resizable()
                .frame(width: 50, height: 50)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16.0))
    }
}

#Preview {
    FlashAlert(title: "Test image", image: Image(systemName: "checkmark.circle.fill"))
}
