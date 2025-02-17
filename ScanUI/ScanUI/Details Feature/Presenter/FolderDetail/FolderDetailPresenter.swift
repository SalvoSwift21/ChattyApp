//
//  UploadFilePresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation
import UIKit

public class FolderDetailPresenter: FolderDetailPresenterProtocol {
    
    internal var resourceBundle: Bundle
    internal var currentProductFeature: ProductFeature
    internal var bannerID: String

    private var service: FolderDetailService
    private weak var delegate: FolderDetailProtocolDelegate?
    
    private var currentFolder: Folder?
    

    public init(delegate: FolderDetailProtocolDelegate,
                service: FolderDetailService,
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
        guard let currentFolder = try? await service.getFolder() else {
            self.delegate?.render(errorMessage: "Error can't load folder")
            return
        }
        self.currentFolder = currentFolder
        self.delegate?.render(viewModel: FolderDetailViewModel(folder: currentFolder))
    }
    
    @MainActor
    func select(scan: Scan) {
        self.delegate?.select(scan: scan)
    }
    
    internal func delete(scan: Scan) async throws {
        try await self.service.deleteScan(scan: scan)
        await self.loadData()
    }
    
    func removeScanRows(at offsets: IndexSet) {
        let scans = offsets.map { self.currentFolder?.scans[$0] }.compactMap({ $0 })
        scans.forEach { scan in
            Task {
                do {
                    try await self.delete(scan: scan)
                }
            }
        }
    }
    
    func getProductInfoAndBanner() -> (ProductFeature, String) {
        (currentProductFeature, bannerID)
    }
}

//MARK: Help for Home
extension FolderDetailPresenter {
    
    @MainActor
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
}
