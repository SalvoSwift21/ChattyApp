//
//  HomeMyRecentScanView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 14/12/23.
//

import SwiftUI

struct HomeMyRecentScanView: View {
    var resourceBundle: Bundle
    var scans: [Scan]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text("Recent Scans")
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.title)
            
            ForEach(scans, id: \.id) { scan in
                ScanItem(resourceBundle: resourceBundle, scan: scan)
                    .onTapGesture {
                        print("Click on \(scan.id)")
                    }
            }
        })
    }
}

struct ScanItem: View {
    var resourceBundle: Bundle = .main
    var scan: Scan
    
    var body: some View {
        HStack(alignment: .center, spacing: 10, content: {
            if let img = scan.mainImage {
                Image(uiImage: img)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 50, height: 50)
            }
            VStack(alignment: .leading, spacing: 5, content: {
                Text(scan.title)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundStyle(.title)
                    .lineLimit(1)
                Text("\(scan.scanDate.ISO8601Format())")
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                    .foregroundStyle(.subtitle)
                    .lineLimit(1)
            })
        })
    }
}

#Preview {
    HomeMyRecentScanView(resourceBundle: Bundle(identifier: "com.ariel.ScanUI") ?? .main, scans: createScans()).padding()
}

