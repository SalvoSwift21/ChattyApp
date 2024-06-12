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
    
    private var scannedResult: ScanProtocolResult
    
    private var textAnalyzerViewModel: TextAnalyzerViewModel
    
    private var currentSaveText: String?

    public init(delegate: TextAnalyzerProtocolDelegate,
                service: TextAnalyzerService,
                scannedResult: ScanProtocolResult,
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
       
        self.showLoader(true)
        
        Task {
            do {
                let summerCell = createChatViewModel(title: "Summurize text:",
                                                     description: nil,
                                                     image: scannedResult.image,
                                                     backgroundColor: .white,
                                                     position: .left)
                
                self.textAnalyzerViewModel.chatHistory.append(summerCell)
                let result = try await self.service.makeSummary(forText: self.scannedResult.stringResult)
//                let result = self.scannedResult.stringResult
                self.showLoader(false)
                self.currentSaveText = result
                let summerResultCell = createChatViewModel(title: nil,
                                                           description: result,
                                                           image: nil,
                                                           backgroundColor: .prime.opacity(0.7),
                                                           position: .right)
                
                self.textAnalyzerViewModel.chatHistory.append(summerResultCell)

                self.showLoader(false)
                self.renderViewModel()
            } catch {
                self.showLoader(false)
                self.delegate?.render(errorMessage: error.localizedDescription)
            }
        }
    }
    
    fileprivate func createChatViewModel(title: String?,
                                         description: String?,
                                         image: UIImage?,
                                         backgroundColor: Color,
                                         position: ChatPosition) -> ChatCellViewModel {
        return ChatCellViewModel(title: title,
                                 description: description,
                                 image: image,
                                 backgroundColor: backgroundColor,
                                 position: position)
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
    
    public func makeTranslation() async {
        guard let currentSaveText = currentSaveText else { return }
        do {
            showLoader(true)
            let trCell = createChatViewModel(title: "Translate Text",
                                             description: nil,
                                             image: nil,
                                             backgroundColor: .white,
                                             position: .left)
            
            self.textAnalyzerViewModel.chatHistory.append(trCell)
            
            let result = try await makeTranslationFromText(text: currentSaveText)
            self.currentSaveText = result
            
            let trResultCell = createChatViewModel(title: nil,
                                                   description: result,
                                                   image: nil,
                                                   backgroundColor: .prime.opacity(0.7),
                                                   position: .right)
            
            self.textAnalyzerViewModel.chatHistory.append(trResultCell)
            showLoader(false)

            await renderViewModel()
        } catch {
            self.delegate?.render(errorMessage: error.localizedDescription)
        }
    }
    
    public func copySummary() {
        UIPasteboard.general.string = currentSaveText
    }
    
    public func doneButtonTapped(withFolder folder: Folder) {
        guard let currentSaveText = currentSaveText else { return }
        let scanToSave = Scan(id: UUID(), title: currentSaveText, scanDate: scannedResult.scanDate, mainImage: scannedResult.image)
        
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

//MARK: Help for Home
extension TextAnalyzerPresenter {
    
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
}
