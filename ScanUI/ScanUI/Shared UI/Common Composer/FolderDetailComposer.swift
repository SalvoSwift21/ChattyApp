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
        folder: Folder,
        client: ScanStorege,
        currentProductFeature: ProductFeature,
        bannerID: String
    ) -> FolderDetailView {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let folderDetailStore = FolderDetailStore()
                
        let folderService = FolderDetailService(folder: folder, client: client)
                
        let folderPresenter = FolderDetailPresenter(delegate: folderDetailStore, service: folderService, currentProductFeature: currentProductFeature, bannerID: bannerID, bundle: bundle)
        
        return FolderDetailView(store: folderDetailStore, presenter: folderPresenter, resourceBundle: bundle)
    }
}

