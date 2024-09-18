//
//  FolderDetailComposer.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/06/24.
//

import Foundation

public final class FolderDetailComposer {
    private init() {}
        
    public static func folderDetailComposedWith(
        folder: Folder
    ) -> FolderDetailView {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let folderDetailStore = FolderDetailStore()
                
        let folderService = FolderDetailService(folder: folder)
                
        let folderPresenter = FolderDetailPresenter(delegate: folderDetailStore, service: folderService, bundle: bundle)
        
        return FolderDetailView(store: folderDetailStore, presenter: folderPresenter, resourceBundle: bundle)
    }
}

