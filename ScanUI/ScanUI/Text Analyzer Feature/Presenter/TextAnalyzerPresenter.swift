//
//  TextAnalyzerPresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation
import UIKit

public class TextAnalyzerPresenter {
        
    public var resourceBundle: Bundle

    private var service: TextAnalyzerService
    private weak var delegate: TextAnalyzerProtocolDelegate?
    
    private var scannedResult: ScanProtocolResult
    private var originalSummaryText: String?
    private var modifySummaryText: String?
    
    private var textAnalyzerViewModel: TextAnalyzerViewModel

    public init(delegate: TextAnalyzerProtocolDelegate,
                service: TextAnalyzerService,
                scannedResult: ScanProtocolResult,
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.scannedResult = scannedResult
        self.resourceBundle = bundle
        self.textAnalyzerViewModel = TextAnalyzerViewModel(text: "", topImage: nil)
    }
    
    @MainActor 
    public func getData() {
        makeSummary()
    }
    
    @MainActor
    fileprivate func makeSummary() {
       
        self.showLoader(true)
        
        Task {
            do {
//                let result = try await self.service.makeSummary(forText: self.scannedResult.stringResult)
                let result = "questa è la stringa che devo mostrare"
                self.showLoader(false)
                self.originalSummaryText = result
                self.textAnalyzerViewModel.text = scannedResult.stringResult
                self.textAnalyzerViewModel.topImage = scannedResult.image
                self.showLoader(false)
                self.delegate?.render(viewModel: textAnalyzerViewModel)
            } catch {
                self.showLoader(false)
                self.delegate?.render(errorMessage: error.localizedDescription)
            }
        }
    }
    

    fileprivate func getScannedTextLanguage() async throws -> String {
        try await self.service.getCurrentLanguage(forText: scannedResult.stringResult)
    }
    
    @MainActor
    fileprivate func makeTranslationFromText(text: String) async throws -> String {
        try await self.service.makeTranslation(forText: text, from: Locale.current, to: Locale.current)
    }
    
    @MainActor
    fileprivate func renderViewModel() {
        self.delegate?.render(viewModel: textAnalyzerViewModel)
    }
}

extension TextAnalyzerPresenter: TextAnalyzerProtocol {
    
    public func makeTranslation() async {
        do {
            showLoader(true)
            let result = try await makeTranslationFromText(text: textAnalyzerViewModel.text)
            textAnalyzerViewModel.text = result
            await renderViewModel()
            showLoader(false)
        } catch {
            self.delegate?.render(errorMessage: error.localizedDescription)
        }
    }
    
    @MainActor 
    public func showOriginalSummary() {
        self.textAnalyzerViewModel.text = self.originalSummaryText ?? ""
        self.renderViewModel()
    }
    
    public func copySummary() {
        UIPasteboard.general.string = self.textAnalyzerViewModel.text
    }
    
    public func doneButtonTapped(withFolder folder: Folder) {
        let scanToSave = Scan(id: UUID(), title: textAnalyzerViewModel.text, scanDate: scannedResult.scanDate, mainImage: scannedResult.image)
        
        Task {
            do {
                try await service.saveCurrentScan(scan: scanToSave, folder: folder)
                self.done()
            } catch {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    public func done() {
        self.delegate?.goBack()
    }
    
    public func back() {
        print("Back home or scan")
    }
    
    public func updateScannedText(text: String) {
        if text != self.originalSummaryText {
            self.modifySummaryText = text
        }
    }
    
    @MainActor 
    public func showModifyText() {
        self.textAnalyzerViewModel.text = self.modifySummaryText ?? ""
        self.renderViewModel()
    }
    
    public func getStoredService() -> ScanStorege {
        return self.service.storageClient
    }
}

//MARK: Help for Home
extension TextAnalyzerPresenter {
    
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
}
