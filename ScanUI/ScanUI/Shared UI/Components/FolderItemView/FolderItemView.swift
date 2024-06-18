//
//  FolderItem.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/06/24.
//

import Foundation
import SwiftUI

struct FolderItemView: View {
    var resourceBundle: Bundle = .main
    var folder: Folder
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            ZStack(alignment: .center, content: {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 115, height: 115)
                    .background(.backgroundFolder)
                    .cornerRadius(18)
                Image("folder_icon", bundle: resourceBundle)
                    .frame(width: 45, height: 45)
                    .shadow(color: Color(red: 0.78, green: 0.86, blue: 0.91).opacity(0.1), radius: 2, x: 0, y: 4)
            })
            VStack(alignment: .leading, spacing: 5, content: {
                Text(folder.title)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundStyle(.title)
                    .lineLimit(1)
                Text("\(folder.scans.count) Items")
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                    .foregroundStyle(.subtitle)
                    .lineLimit(1)
            })
        }).frame(width: 115)
    }
}

#Preview {
    VStack {
        @State var folder = Folder(title: "Test folder view", scans: [])
        FolderItemView(resourceBundle: Bundle(identifier: "com.ariel.ScanUI") ?? .main, folder: folder)
    }
}
