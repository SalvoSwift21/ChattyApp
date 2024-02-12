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
    
    private var scannedText: String
    private var originalSummaryText: String?
    private var modifySummaryText: String?
    
    private var textAnalyzerViewModel: TextAnalyzerViewModel

    public init(delegate: TextAnalyzerProtocolDelegate,
                service: TextAnalyzerService,
                scannedText: String,
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.scannedText = scannedText
        self.resourceBundle = bundle
        self.textAnalyzerViewModel = TextAnalyzerViewModel(text: "")
    }
    
    public func getData() {
        makeSummary()
    }
    
    fileprivate func makeSummary() {
       
        self.showLoader(true)
        
        Task {
            do {
                let result = try await self.service.makeSummary(forText: scannedText)
                self.showLoader(false)
                self.originalSummaryText = result
                self.textAnalyzerViewModel.text = result
                self.delegate?.render(viewModel: textAnalyzerViewModel)
                self.showLoader(false)
            } catch {
                self.showLoader(false)
                self.delegate?.render(errorMessage: error.localizedDescription)
            }
        }
    }
    

    fileprivate func getScannedTextLanguage() throws -> String {
        try self.service.identificationLanguageClient.identifyLanguageProtocol(fromText: scannedText)
    }
    
    fileprivate func makeTranslationFromText(text: String) async throws -> String {
        try await self.service.makeTranslation(forText: text, from: Locale.current, to: Locale.current)
    }
    
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
            renderViewModel()
            showLoader(false)
        } catch {
            self.delegate?.render(errorMessage: error.localizedDescription)
        }
    }
    
    public func showOriginalSummary() {
        self.textAnalyzerViewModel.text = self.originalSummaryText ?? ""
        self.renderViewModel()
    }
    
    public func copySummary() {
        UIPasteboard.general.string = self.textAnalyzerViewModel.text
    }
    
    public func done() {
        print("Save")
    }
    
    public func back() {
        print("Back home or scan")
    }
    
    public func updateScannedText(text: String) {
        if text != self.originalSummaryText {
            self.modifySummaryText = text
        }
    }
    
    public func showModifyText() {
        self.textAnalyzerViewModel.text = self.modifySummaryText ?? ""
        self.renderViewModel()
    }
}

//MARK: Help for Home
extension TextAnalyzerPresenter {
    
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
}
