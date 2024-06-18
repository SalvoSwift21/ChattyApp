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
        
    public static func homeComposedWith(
        client: ScanStorege,
        upload: @escaping () -> Void = {  },
        newScan: @escaping () -> Void = {  },
        scanTapped: @escaping (Scan) -> Void = { _ in },
        sellAllButton: @escaping () -> Void = {  }
    ) -> HomeView {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let homeStore = HomeStore()
        let homeService = HomeService(client: client)
                
        let homePresenter = HomePresenter(service: homeService,
                                          delegate: homeStore,
                                          uploadImage: upload,
                                          newScan: newScan,
                                          sellAllButton: sellAllButton, 
                                          scanTapped: scanTapped,
                                          bundle: bundle)
        
        return HomeView(store: homeStore, presenter: homePresenter, resourceBundle: bundle)
    }
}
