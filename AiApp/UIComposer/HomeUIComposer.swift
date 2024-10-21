//
//  HomeUIComposer.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 18/12/23.
//

import Foundation
import RestApi
import ScanUI


public final class HomeUIComposer {
    private init() {}
    
    static var homeStore: HomeStore?
        
    public static func homeComposedWith(
        client: ScanStorege,
        upload: @escaping () -> Void = {  },
        newScan: @escaping () -> Void = {  },
        scanTapped: @escaping (Scan) -> Void = { _ in },
        folderTapped: @escaping (Folder) -> Void = { _ in },
        sellAllButton: @escaping () -> Void = {  },
        menuButton: @escaping () -> Void = {  }
    ) -> HomeView {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let homeStore = HomeStore()
        let homeService = HomeService(client: client)
        
        if HomeUIComposer.homeStore == nil {
            HomeUIComposer.homeStore = homeStore
        }
                
        let homePresenter = HomePresenter(service: homeService,
                                          delegate: HomeUIComposer.homeStore ?? homeStore,
                                          uploadImage: upload,
                                          newScan: newScan,
                                          sellAllButton: sellAllButton, 
                                          scanTapped: scanTapped,
                                          folderTapped: folderTapped,
                                          menuButton: menuButton,
                                          bundle: bundle)
        
        return HomeView(store: HomeUIComposer.homeStore ?? homeStore, presenter: homePresenter, resourceBundle: bundle)
    }
}
