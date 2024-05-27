//
//  FoldersViewComposer.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 21/05/24.
//

import Foundation

public final class FoldersViewComposer {
    private init() {}
        
    public static func foldersComposedWith(
        client: ScanStorege,
        didSelectFolder: @escaping (Folder) -> Void = { _ in }
    ) -> AllFoldersView {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let foldersStore = FoldersStore()
                
        let foldersService = FoldersLocalService(client: client)
                
        let foldersPresenter = FoldersPresenter(delegate: foldersStore,
                                             service: foldersService,
                                             didSelectFolder: didSelectFolder,
                                             bundle: bundle)
        
        return AllFoldersView(store: foldersStore, presenter: foldersPresenter, resourceBundle: bundle)
    }
}
