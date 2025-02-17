//
//  UploadFilePresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation
import UIKit

public class ScanDetailPresenter: ScanDetailPresenterProtocol {
    
    internal var resourceBundle: Bundle
    internal var currentProductFeature: ProductFeature
    internal var bannerID: String
    
    private var service: ScanDetailService
    private weak var delegate: ScanDetailProtocolDelegate?
    
    private var currentScan: Scan?
    

    public init(delegate: ScanDetailProtocolDelegate,
                service: ScanDetailService,
                currentProductFeature: ProductFeature,
                bannerID: String,
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.resourceBundle = bundle
        self.currentProductFeature = currentProductFeature
        self.bannerID = bannerID
    }
    
    @MainActor
    func loadData() async {
        let currentScan = await service.getScan()
        self.currentScan = currentScan
        self.delegate?.render(viewModel: ScanDetailViewModel(scan: currentScan))
    }
    
    func showADBanner() -> Bool {
        !currentProductFeature.features.contains(where: { $0 == .removeAds })
    }
    
    func copyContent() {
        guard let text = currentScan?.contentText else { return }
        UIPasteboard.general.string = text
    }
    
    //MARK: AD SERVICE
    public func getADBannerID() -> String {
        bannerID
    }
}

//MARK: Help for Home
extension ScanDetailPresenter {
    
    @MainActor
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
}
