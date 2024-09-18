//
//  HomeMyFoldesView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 13/12/23.
//

import SwiftUI

struct HomeMyFoldesView: View {
    var resourceBundle: Bundle
    var folders: [Folder]
    var viewAllButtonTapped: (() -> Void)
    var folderTapped: ((Folder) -> Void)

    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            HStack(content: {
                Text("My Folders")
                    .font(.system(size: 22))
                    .fontWeight(.semibold)
                    .foregroundStyle(.title)
                Spacer()
                Button(action: {
                    viewAllButtonTapped()
                }, label: {
                    Text("See All >")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundStyle(.prime)
                })
            })
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 15, content: {
                    ForEach(folders, id: \.id) { folder in
                        FolderItemView(resourceBundle: resourceBundle, folder: folder)
                            .onTapGesture {
                                folderTapped(folder)
                            }
                    }
                })
            }
        })
    }
}

#Preview {
    HomeMyFoldesView(resourceBundle: Bundle(identifier: "com.ariel.ScanUI") ?? .main, folders: createSomeFolders(), viewAllButtonTapped: { }, folderTapped: { _ in })
        .padding()
}
