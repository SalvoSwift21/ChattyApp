//
//  ScanPresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import Foundation
import OCRFeature
import UIKit
import VisionKit
import UniformTypeIdentifiers


public class ScanPresenter: ScanProtocols {
    
    public var resourceBundle: Bundle
    public var resultOfScan: ((ScanResult) -> Void)

    private var service: ScanService
    private var dataScannerDelegate = DataScannerOCRClientDelegate()
    private weak var delegate: (ScanProtocolsDelegate & ScanButtonProtocolDelegate)?

    private var lastItem: RecognizedItem?

    @MainActor
    public init(delegate: ScanProtocolsDelegate & ScanButtonProtocolDelegate,
                resultOfScan: @escaping ((ScanResult) -> Void),
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        let dataScannerOCR = DataScannerOCRClient(delegate: self.dataScannerDelegate, recognizedDataType: [.text()])
        self.service = ScanService(dataScannerOCRClient: dataScannerOCR)
        self.delegate = delegate
        self.resourceBundle = bundle
        self.resultOfScan = resultOfScan
        
        self.setConcreteDelegateCompletion()
    }
    
    @MainActor
    private func setConcreteDelegateCompletion() {
        self.dataScannerDelegate.recognizedItemCompletion = { scanResult in
            self.showLoader(false)
            self.resultOfScan(ScanResult(stringResult: scanResult.0, scanDate: Date(), fileData: scanResult.1?.pngData(), fileType: UTType.png.identifier))
        }
        
        self.dataScannerDelegate.errorOnScanning = { error in
            self.showLoader(false)
            self.delegate?.render(errorMessage: error.localizedDescription)
        }
        
        self.dataScannerDelegate.didRecognizeItems = { items in
            self.delegate?.enabledButton(items.count > 0)
            self.lastItem = items.last
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
    
    
    public func goBack() {
        self.delegate?.goBack()
    }
    
    public func shutterButtonTapped() {
        Task {
            guard let lastItem = self.lastItem else { return }
            switch lastItem {
            case .text(let text):
                await self.service.handleTappingItem(text: text.transcript)
                await self.stopScan()
            default:
                return
            }
        }
    }
}

//MARK: Help for Home
extension ScanPresenter {
    
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
}
