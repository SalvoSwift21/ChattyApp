//
//  HomeSearchResultView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/09/24.
//

import SwiftUI

struct HomeSearchResultView: View {
    var resourceBundle: Bundle
    
    var folders: [Folder]
    var scans: [Scan]
    
    var scanTapped: ((Scan) -> Void)
    var folderTapped: ((Folder) -> Void)

    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            if folders.count > 0 {
                HStack {
                    VStack(alignment: .leading, spacing: 10, content: {
                        Text("Folders")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .foregroundStyle(.title)
                        
                        ForEach(folders, id: \.id) { folder in
                            FolderItemView(resourceBundle: resourceBundle, folder: folder, isHorizontal: true)
                                .onTapGesture {
                                    folderTapped(folder)
                                }
                        }
                    })
                    
                    Spacer()
                }
            }
            
            if scans.count > 0 {
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("Scans")
                        .font(.system(size: 22))
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
        })
    }
}


#Preview {
    ScrollView {
        HomeSearchResultView(resourceBundle: Bundle(identifier: "com.ariel.ScanUI") ?? .main, folders: createSomeFolders(), scans: createScans()) { _ in
            
        } folderTapped: { _ in
            
        }
    }.padding()
}
