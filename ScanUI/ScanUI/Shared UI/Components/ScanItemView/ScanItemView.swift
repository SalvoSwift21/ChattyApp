//
//  ScanItemView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/06/24.
//

import Foundation
import SwiftUI

struct ScanItemView: View {
    var resourceBundle: Bundle = .main
    var scan: Scan
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center, spacing: 15, content: {
                if let img = scan.mainImage {
                    Image(uiImage: img)
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 60, height: 60)
                        .clipShape(.rect(cornerRadius: 5.0))
                }
                
                VStack(alignment: .leading, spacing: 5, content: {
                    Text(scan.title)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundStyle(.title)
                        .lineLimit(2)
                    
                    Text("\(scan.scanDate.recentScanMode())")
                        .font(.system(size: 12))
                        .fontWeight(.regular)
                        .foregroundStyle(.subtitle)
                        .lineLimit(1)
                })
            })
            
            Divider()
        }
    }
}

#Preview {
    VStack {
        ScanItemView(resourceBundle: Bundle(identifier: "com.ariel.ScanUI") ?? .main,
                     scan: Scan(title: "Test scan title",
                                contentText: "Test conten", scanDate: .now,
                                mainImage: UIImage(named: "default_scan", in: Bundle(identifier: "com.ariel.ScanUI"), with: nil)))
    }.padding()
}
