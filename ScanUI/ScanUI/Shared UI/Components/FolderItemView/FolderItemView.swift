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
    
    var isHorizontal: Bool = false
    
    var body: some View {
        if isHorizontal {
            HStack(spacing: 15, content: {
                iconView
                infoView
                Spacer()
            })
        } else {
            VStack(alignment: .leading, spacing: 10, content: {
                iconView
                infoView
            })
            .background(.clear)
            .padding()
            .frame(width: 130)
        }
    }
    
    private var iconView: some View {
        ZStack(alignment: .center, content: {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: isHorizontal ? 60 : 115, height: isHorizontal ? 60 : 115)
                .background(.backgroundFolder)
                .cornerRadius(18)
            Image("folder_icon", bundle: resourceBundle)
                .resizable()
                .frame(width: isHorizontal ? 30 : 65, height: isHorizontal ? 30 : 65)
                .shadow(color: Color(red: 0.78, green: 0.86, blue: 0.91).opacity(0.1), radius: 2, x: 0, y: 4)
        }).background(.clear)
    }
    
    private var infoView: some View {
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
    }
}

#Preview {
    VStack {
        @State var folder = Folder(title: "Test folder view", scans: [])
        
        FolderItemView(resourceBundle: Bundle(identifier: "com.ariel.ScanUI") ?? .main, folder: folder)
        
        @State var folders = Folder(title: "Test folder view", scans: [])
        VStack {
            FolderItemView(resourceBundle: Bundle(identifier: "com.ariel.ScanUI") ?? .main, folder: folder, isHorizontal: true)
        }
        
    }
}
