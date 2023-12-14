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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            HStack(content: {
                Text("My scans")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.title)
                Spacer()
                Button(action: {
                    print("Nothing to do for now")
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
                        FolderItem(resourceBundle: resourceBundle, folder: folder)
                            .onTapGesture {
                                print("Click on \(folder.id)")
                            }
                    }
                })
            }
        })
    }
}

struct FolderItem: View {
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
    HomeMyFoldesView(resourceBundle: Bundle(identifier: "com.ariel.ScanUI") ?? .main, folders: createSomeFolders())
        .padding()
}

func createSomeFolders() -> [Folder] {
    let scans = createScans()
    let folder = Folder(title: "Personal", scans: scans)
    let folder1 = Folder(title: "Official", scans: scans)
    let folder2 = Folder(title: "Other", scans: scans)
    let folder3 = Folder(title: "Altre cose con nome lungo", scans: scans)
    return [folder, folder1, folder2, folder3]
}

func createScans() -> [Scan] {
    return [Scan(title: "Prima Scansione", scanDate: .now, mainImage: UIImage(named: "default_scan", in: Bundle(identifier: "com.ariel.ScanUI"), with: nil)),
            Scan(title: "Seconda Scansione", scanDate: .now, mainImage: UIImage(named: "default_scan", in: Bundle(identifier: "com.ariel.ScanUI"), with: nil)),
            Scan(title: "Terza scansione", scanDate: .now, mainImage: UIImage(named: "default_scan", in: Bundle(identifier: "com.ariel.ScanUI"), with: nil))]
}
