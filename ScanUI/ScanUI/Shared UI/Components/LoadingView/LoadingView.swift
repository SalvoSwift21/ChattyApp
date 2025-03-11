//
//  LoadingView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 04/12/23.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color.clear
            Circle()
                .trim(from: 0.1, to: 1.0)
                .stroke(Color.prime, lineWidth: 3)
                .frame(width: 30, height: 30)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
        }
    }

}


#Preview {
    VStack {
        LoadingView()
    }
}
