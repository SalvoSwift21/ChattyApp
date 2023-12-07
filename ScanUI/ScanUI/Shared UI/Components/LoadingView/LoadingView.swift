//
//  LoadingView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 04/12/23.
//

import SwiftUI

struct LoadingView: View {
    @State private var progress: Double = 0.0

    var body: some View {
        ProgressView(value: progress, total: 1.0)
            .progressViewStyle(LoadingViewDefaultStyle())
            .onAppear {
                withAnimation(Animation.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    progress = 1.0
                }
            }
    }
}


#Preview {
    LoadingView()
}
