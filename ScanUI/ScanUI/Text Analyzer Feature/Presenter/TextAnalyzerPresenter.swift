//
//  TextAnalyzerPresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation
import UIKit
import SwiftUI

public class TextAnalyzerPresenter {
        
    public var resourceBundle: Bundle

    private var service: TextAnalyzerService
    private weak var delegate: TextAnalyzerProtocolDelegate?
    
    private var scannedResult: ScanResult
    
    private var textAnalyzerViewModel: TextAnalyzerViewModel
    
    private var currentSaveText: String?

    public init(delegate: TextAnalyzerProtocolDelegate,
                service: TextAnalyzerService,
                scannedResult: ScanResult,
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.scannedResult = scannedResult
        self.resourceBundle = bundle
        self.textAnalyzerViewModel = TextAnalyzerViewModel(chatHistory: [])
    }
    
    @MainActor 
    public func getData() {
        makeSummary()
    }
    
    @MainActor
    fileprivate func makeSummary() {
        Task {
            do {
                let summerCell = createChatViewModel(title: "Summurize my content",
                                                     description: nil,
                                                     image: scannedResult.image,
                                                     backgroundColor: .white,
                                                     position: .left,
                                                     isInLoading: false)
                
                
                self.textAnalyzerViewModel.chatHistory.append(summerCell)
                
                let summerResultCell = createChatViewModel(title: nil,
                                                           description: "",
                                                           image: nil,
                                                           backgroundColor: .prime.opacity(0.7),
                                                           position: .right,
                                                           isInLoading: true)
                
                self.textAnalyzerViewModel.chatHistory.append(summerResultCell)

                self.renderViewModel()
                
                let result = try await self.service.makeSummary(forText: self.scannedResult.stringResult)
                self.currentSaveText = result
                
                summerResultCell.description = result
                summerResultCell.isInLoading = false
                
                self.renderViewModel()
            } catch {
                self.delegate?.render(errorMessage: error.localizedDescription)
            }
        }
    }
    
    fileprivate func createChatViewModel(title: String?,
                                         description: String?,
                                         image: UIImage?,
                                         backgroundColor: Color,
                                         position: ChatPosition,
                                         isInLoading: Bool) -> ChatCellViewModel {
        return ChatCellViewModel(title: title,
                                 description: description,
                                 image: image,
                                 backgroundColor: backgroundColor,
                                 position: position,
                                 isInLoading: isInLoading)
    }
    
    
    @MainActor
    fileprivate func makeTranslationFromText(text: String) async throws -> String {
        try await self.service.makeTranslation(forText: text, to: .current)
    }
    
    @MainActor
    fileprivate func renderViewModel() {
        self.delegate?.render(viewModel: textAnalyzerViewModel)
    }
}

extension TextAnalyzerPresenter: TextAnalyzerProtocol {
    
    @MainActor
    public func makeTranslation() async {
        guard let currentSaveText = currentSaveText else { return }
        do {
            let trCell = createChatViewModel(title: "Translate",
                                             description: nil,
                                             image: nil,
                                             backgroundColor: .white,
                                             position: .left, isInLoading: false)
            
            self.textAnalyzerViewModel.chatHistory.append(trCell)
            
            let trResultCell = createChatViewModel(title: nil,
                                                   description: "",
                                                   image: nil,
                                                   backgroundColor: .prime.opacity(0.7),
                                                   position: .right, isInLoading: true)
            
            self.textAnalyzerViewModel.chatHistory.append(trResultCell)
            
            self.renderViewModel()

            let result = try await makeTranslationFromText(text: currentSaveText)
            self.currentSaveText = result
            
            trResultCell.description = result
            trResultCell.isInLoading = false
            
            self.renderViewModel()
        } catch {
            self.delegate?.render(errorMessage: error.localizedDescription)
        }
    }
    
    public func copySummary() {
        UIPasteboard.general.string = currentSaveText
    }
    
    public func doneButtonTapped(withFolder folder: Folder) {
        guard let currentSaveText = currentSaveText else { return }
        let scanToSave = Scan(id: UUID(), title: currentSaveText, contentText: currentSaveText, scanDate: scannedResult.scanDate, mainImage: scannedResult.image)
        
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
    
    public func getStoredService() -> ScanStorege {
        return self.service.storageClient
    }
}
