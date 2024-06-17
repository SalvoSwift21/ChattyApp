//
//  ScanPresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import Foundation
import OCRFeature


public class ScanPresenter: ScanProtocols {
    
    public var resourceBundle: Bundle
    public var resultOfScan: ((ScanResult) -> Void)

    private var service: ScanService
    private var ocrConcreteDelegate = ConcrateOCRClientDelegate()
    private weak var delegate: ScanProtocolsDelegate?
    

    @MainActor
    public init(delegate: ScanProtocolsDelegate,
                resultOfScan: @escaping ((ScanResult) -> Void),
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        let dataScannerOCR = DataScannerOCRClient(delegate: self.ocrConcreteDelegate, recognizedDataType: [.text()])
        self.service = ScanService(dataScannerOCRClient: dataScannerOCR)
        self.delegate = delegate
        self.resourceBundle = bundle
        self.resultOfScan = resultOfScan
        
        self.setConcreteDelegateCompletion()
    }
    
    private func setConcreteDelegateCompletion() {
        self.ocrConcreteDelegate.recognizedItemCompletion = { scanResult in
            self.showLoader(false)
            self.resultOfScan(ScanResult(stringResult: scanResult.0, scanDate: Date(), image: scanResult.1))
        }
        
        self.ocrConcreteDelegate.errorOnScanning = { error in
            self.showLoader(false)
            self.delegate?.render(errorMessage: error.localizedDescription)
        }
    }
    
    @MainActor 
    public func startScan() {
        self.showLoader(false)
        do {
            try self.service.startDataScanner()
        } catch {
            self.delegate?.render(errorMessage: error.localizedDescription)
            return
        }
        let controller = self.service.dataScannerOCRClient.getCurrentDataScannerController()
        let vModel = ScanViewModel(dataScannerController: controller)
        self.delegate?.render(viewModel: vModel)
    }
    
    @MainActor 
    public func stopScan() {
        self.showLoader(false)
        do {
            try self.service.stopDataScanner()
        } catch {
            self.delegate?.render(errorMessage: error.localizedDescription)
            return
        }
        let controller = self.service.dataScannerOCRClient.getCurrentDataScannerController()
        let vModel = ScanViewModel(dataScannerController: controller)
        self.delegate?.render(viewModel: vModel)
    }
}

//MARK: Help for Home
extension ScanPresenter {
    
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
}
