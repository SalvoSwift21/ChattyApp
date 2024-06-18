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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            HStack(content: {
                Text("My scans")
                    .font(.system(size: 18))
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
                                print("Click on \(folder.id)")
                            }
                    }
                })
            }
        })
    }
}

#Preview {
    HomeMyFoldesView(resourceBundle: Bundle(identifier: "com.ariel.ScanUI") ?? .main, folders: createSomeFolders(), viewAllButtonTapped: { })
        .padding()
}
