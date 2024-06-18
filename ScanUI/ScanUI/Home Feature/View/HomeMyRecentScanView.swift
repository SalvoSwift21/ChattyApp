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
        VStack(alignment: .leading, spacing: 5, content: {
            Text("Recent Scans")
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.title)
            
            ForEach(scans, id: \.id) { scan in
                ScanItemView(resourceBundle: resourceBundle, scan: scan)
                    .onTapGesture {
                        scanTapped(scan)
                    }
            }
        })
    }
}


#Preview {
    HomeMyRecentScanView(resourceBundle: Bundle(identifier: "com.ariel.ScanUI") ?? .main, scans: createScans(), scanTapped: { _ in }).padding()
}

