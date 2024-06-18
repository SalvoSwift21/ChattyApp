//
//  ScanDetailViewComposer.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/06/24.
//

import Foundation


public final class ScanDetailViewComposer {
    private init() {}
        
    public static func scanDetailComposedWith(
        scan: Scan
    ) -> ScanDetailView {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let scanDetailStore = ScanDetailStore()
                
        let scanService = ScanDetailService(scan: scan)
                
        let scanPresenter = ScanDetailPresenter(delegate: scanDetailStore, service: scanService, bundle: bundle)
        
        return ScanDetailView(store: scanDetailStore, presenter: scanPresenter, resourceBundle: bundle)
    }
}
