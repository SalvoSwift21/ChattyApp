//
//  ContentView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 3/20/25.
//

import SwiftUI


public struct WebViewSwiftUI: View {
    @Environment(\.dismiss) var dismiss

    var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        WebView(url: url)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
    }
}
