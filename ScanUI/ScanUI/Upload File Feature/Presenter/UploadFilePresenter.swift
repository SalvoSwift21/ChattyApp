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

    private var service: UploadFileServiceProtocol
    private weak var delegate: UploadFileProtocolsDelegate?
    

    public init(delegate: UploadFileProtocolsDelegate,
                service: UploadFileServiceProtocol,
                resultOfScan: @escaping ((ScanResult) -> Void),
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.resourceBundle = bundle
        self.resultOfScan = resultOfScan
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
}
