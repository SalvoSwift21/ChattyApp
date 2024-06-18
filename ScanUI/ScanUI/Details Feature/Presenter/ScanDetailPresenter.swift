//
//  UploadFilePresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation
import OCRFeature
import UIKit

public class ScanDetailPresenter: ScanDetailPresenterProtocol {
    
    internal var resourceBundle: Bundle

    private var service: ScanDetailService
    private weak var delegate: ScanDetailProtocolDelegate?
    
    private var currentScan: Scan?
    

    public init(delegate: ScanDetailProtocolDelegate,
                service: ScanDetailService,
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.resourceBundle = bundle
    }
    
    func loadData() async {
        let currentScan = await service.getScan()
        self.currentScan = currentScan
        self.delegate?.render(viewModel: ScanDetailViewModel(scan: currentScan))
    }
    
    func copyContent() {
        guard let text = currentScan?.contentText else { return }
        UIPasteboard.general.string = text
    }
}

//MARK: Help for Home
extension ScanDetailPresenter {
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
}
