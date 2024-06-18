//
//  CircleAnimationView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 16/12/23.
//

import SwiftUI

struct CircleAnimationView: View {
    
    var centerImage: UIImage
    var frame: CGSize
    
    var borderColor: Color = .footer
    var mainColor: Color = .prime
    
    @State private var shadowRadius: Double = 0.0
    @State private var borderValue: Double = 0.0

    var body: some View {
        ZStack(alignment: .center, content: {
            Circle()
                .stroke(borderColor.opacity(borderValue), lineWidth: 1)
                .foregroundColor(.clear)
                .frame(width: frame.width, height: frame.height, alignment: .center)
                .animation(.easeInOut(duration: 4.0), value: borderValue)
            Circle()
                .foregroundStyle(mainColor)
                .frame(width: (frame.width/1.7), height: (frame.height/1.7))
                .shadow(color: mainColor.opacity(0.9), radius: shadowRadius, x: 0.0, y: 0.0)
                .animation(.easeInOut(duration: 4.0), value: shadowRadius)
                .task({
                    _ = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { timer in
                        let value = shadowRadius == 0.0 ? (frame.width/4.0) : 0.0
                        shadowRadius = value
                        let valueBorder = borderValue == 0.0 ? 0.4 : 0.4
                        borderValue = valueBorder
                    }
                })
            Image(uiImage: centerImage)
                .resizable()
                .scaledToFit()
                .frame(width: (frame.width/4.0), height: (frame.height/4.0), alignment: .center)
        })
    }
}

#Preview {
    CircleAnimationView(centerImage: UIImage(named: "scan_icon", in: .init(identifier: "com.ariel.ScanUI"), with: nil) ?? UIImage(), frame: .init(width: 64, height: 64))
}
