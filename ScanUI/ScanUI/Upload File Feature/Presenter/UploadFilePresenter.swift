//
//  UploadFilePresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation
import OCRFeature

public class UploadFilePresenter: UploadFileProtocols {
    
    
    public var resourceBundle: Bundle
    public var resultOfScan: ((String) -> Void)

    private var service: UploadFileService
    private var ocrConcreteDelegate = ConcrateOCRClientDelegate()
    private weak var delegate: UploadFileProtocolsDelegate?
    

    public init(delegate: UploadFileProtocolsDelegate,
                resultOfScan: @escaping ((String) -> Void),
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        let imgScanner = ImageScannerOCRClient(delegate: self.ocrConcreteDelegate)
        self.service = UploadFileService(imageScannerOCRClient: imgScanner)
        self.delegate = delegate
        self.resourceBundle = bundle
        self.resultOfScan = resultOfScan
        
        self.setConcreteDelegateCompletion()
    }
    
    private func setConcreteDelegateCompletion() {
        self.ocrConcreteDelegate.recognizedItemCompletion = { text in
            self.showLoader(false)
            self.resultOfScan(text)
        }
        
        self.ocrConcreteDelegate.errorOnScanning = { error in
            self.showLoader(false)
            self.delegate?.render(errorMessage: error.localizedDescription)
        }
    }
    
    public func startScan(atURL url: URL) async throws {
        self.showLoader(true)
        try await self.service.startScan(atURL: url)
    }
    
    @MainActor
    @Sendable public func loadFilesType() async {
        let uttTypes = await self.service.getFileUTTypes()
        let viewModel = UploadFileViewModel(fileTypes: uttTypes)
        self.delegate?.render(viewModel: viewModel)
    }
}

//MARK: Help for Home
extension UploadFilePresenter {
    
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
}
