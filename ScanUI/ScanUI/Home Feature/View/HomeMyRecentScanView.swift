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
    var scanTapped: ((Scan) -> Void)

    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Text("Recent Scans")
                .font(.system(size: 22))
                .fontWeight(.semibold)
                .foregroundStyle(.title)
            
            ForEach(scans, id: \.id) { scan in
                Button {
                    scanTapped(scan)
                } label: {
                    ScanItemView(resourceBundle: resourceBundle, scan: scan)
                }
            }
        })
    }
}


#Preview {
    HomeMyRecentScanView(resourceBundle: Bundle(identifier: "com.ariel.ScanUI") ?? .main, scans: createScans(), scanTapped: { _ in }).padding()
}

