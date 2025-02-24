//
//  UploadFilePresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation

public class UploadFilePresenter: UploadFileProtocols {
    
    public var resourceBundle: Bundle
    public var resultOfScan: ((ScanResult) -> Void)
    private let adViewModel: InterstitialViewModel

    public var currentProductFeature: ProductFeature

    private var service: UploadFileServiceProtocol
    private weak var delegate: UploadFileProtocolsDelegate?
    

    public init(delegate: UploadFileProtocolsDelegate,
                service: UploadFileServiceProtocol,
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main,
                currentProductFeature: ProductFeature,
                interstitialID: String,
                resultOfScan: @escaping ((ScanResult) -> Void)) {
        self.service = service
        self.delegate = delegate
        self.resourceBundle = bundle
        self.resultOfScan = resultOfScan
        self.currentProductFeature = currentProductFeature
        self.adViewModel = InterstitialViewModel(id: interstitialID)
    }
    
    
    @MainActor
    public func startScan(atURL url: URL) async {
        do {
            let scanResult = try await self.service.startScan(atURL: url)
            resultOfScan(scanResult)
        } catch {
            self.delegate?.render(errorMessage: error.localizedDescription)
        }
    }
    
    @MainActor
    @Sendable public func loadFilesType() async {
        let uttTypes = await self.service.getFileUTTypes()
        let viewModel = UploadFileViewModel(fileTypes: uttTypes)
        self.delegate?.render(viewModel: viewModel)
    }
    
    @MainActor
    @Sendable public func loadAd() async {
        if adIsEnabled() {
            await adViewModel.loadAd()
        }
    }
    
    @MainActor
    public func handleTryAgain() {
        self.delegate?.resetErrorState()
    }
    
    @MainActor
    public func handleCancelAction() {
        self.delegate?.resetErrorState()
    }
    
    public func adIsEnabled() -> Bool {
        !currentProductFeature.features.contains(.removeAds)
    }
    
    public func showAdvFromViewModel() {
        adViewModel.showAd()
    }
    
}
