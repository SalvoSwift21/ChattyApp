//
//  TextAnalyzerPresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation
import UIKit
import SwiftUI

public class TextAnalyzerPresenter: ObservableObject {
        
    public var resourceBundle: Bundle

    private var service: TextAnalyzerService
    private weak var delegate: TextAnalyzerProtocolDelegate?
    
    private var doneCompletion: () -> Void = {  }
    
    private var scannedResult: ScanResult
    
    private var textAnalyzerViewModel: TextAnalyzerViewModel
    
    private var currentSaveText: String?
    private var currentSaveTitle: String?
    
    private var currentProductFeature: ProductFeature
    private var bannerID: String
    private var storeViewTapped: (() -> Void)

    public init(delegate: TextAnalyzerProtocolDelegate,
                service: TextAnalyzerService,
                scannedResult: ScanResult,
                currentProductFeature: ProductFeature,
                bannerID: String,
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main,
                done: @escaping () -> Void = {  },
                storeViewTapped: @escaping (() -> Void)) {
        self.service = service
        self.delegate = delegate
        self.scannedResult = scannedResult
        self.resourceBundle = bundle
        self.doneCompletion = done
        self.textAnalyzerViewModel = TextAnalyzerViewModel(chatHistory: [])
        self.currentProductFeature = currentProductFeature
        self.bannerID = bannerID
        self.storeViewTapped = storeViewTapped
    }
    
    @MainActor 
    public func getData() async {
        self.textAnalyzerViewModel.chatHistory.removeAll()
        await makeSummary(forScan: scannedResult)
    }
    

    @MainActor
    fileprivate func makeSummary(forScan scan: ScanResult) async {
        do {
            let image = getCorrectPlaceholderImage(forScan: scan)
            let summerCell = createChatViewModel(title: "TEXT_ANALYZER_SUMMURIZE_ACTION",
                                                 description: nil,
                                                 image: image,
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
            
            let result = try await self.chooseSummaryService(scan)
            self.currentSaveText = result
            
            summerResultCell.description = result
            summerResultCell.isInLoading = false
            
            self.renderViewModel()
        } catch {
            self.delegate?.renderErrorSummary(errorMessage: error.localizedDescription)
        }
    }
}

//Helper
extension TextAnalyzerPresenter {
    
    @MainActor
    fileprivate func makeTranslationFromText(text: String) async throws -> String {
        try await self.service.makeTranslation(forText: text)
    }
    
    fileprivate func chooseSummaryService(_ scan: ScanResult) async throws -> String {
        guard let type = scan.getFileUTType()?.preferredMIMEType, let data = scan.fileData, scan.stringResult.isEmpty else {
            return try await self.service.makeSummary(forText: scan.stringResult)
        }
        
        return try await self.service.makeSummary(forData: data, mimeType: type)
    }
    
    @MainActor
    fileprivate func renderViewModel() {
        self.delegate?.render(viewModel: textAnalyzerViewModel)
    }
    
    
    fileprivate func getCorrectPlaceholderImage(forScan scan: ScanResult) -> UIImage {
        
        let placeholderImage = UIImage(systemName: "document")?.withTintColor(.prime.withAlphaComponent(0.7), renderingMode: .alwaysTemplate)
        
//        let icon = getIconFromDocumentController(data: scan.fileData ?? Data())
        
        let scanImageData = UIImage(data: scan.fileData ?? Data())
        
        return scanImageData ?? placeholderImage ?? UIImage()
    }
    
    fileprivate func getIconFromDocumentController(data: Data) -> UIImage? {
        let tempUrl = URL(fileURLWithPath: NSTemporaryDirectory())
        try? data.write(to: tempUrl)
        
        let controller = UIDocumentInteractionController(url: tempUrl)
        let image = controller.icons.first
        
        try? FileManager.default.removeItem(at: tempUrl)
        
        return image
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
    
    //MARK: AD SERVICE
    public func getADBannerID() -> String {
        bannerID
    }
    
    public func getCurrentProductFeature() -> ProductFeature {
        currentProductFeature
    }
}

extension TextAnalyzerPresenter: TextAnalyzerProtocol {
    
    public func handleErrorPrimaryAction(state: TextAnalyzerStore.ErrorState) {
        self.delegate?.resetErrorState()
        switch state {
        case .errorSummary:
            Task {
                await self.getData()
            }
        case .errorTR:
            Task {
                await self.makeTranslation()
            }
        case .saveError(_, let folder):
            Task {
                await self.doneButtonTapped(withFolder: folder)
            }
        }
    }
    
    public func handleErrorSecondaryAction(state: TextAnalyzerStore.ErrorState) {
        self.delegate?.resetErrorState()
        switch state {
        case .errorSummary:
            delegate?.goBack()
        case .errorTR: break
        case .saveError: break
        }
    }
    
    public func addTitle(_ title: String) {
        self.currentSaveTitle = title
    }
    
    public func transactionFeatureIsEnabled() -> Bool {
        currentProductFeature.features.contains(where: { $0 == .translation })
    }
    
    public func adMobIsEnabled() -> Bool {
        !currentProductFeature.features.contains(where: { $0 == .removeAds })
    }
    
    @MainActor
    public func makeTranslation() async {
        guard let currentSaveText = currentSaveText else { return }
        do {
            let trCell = createChatViewModel(title: "GENERIC_TRANSLATE_ACTION",
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
            self.delegate?.renderErrorTr(errorMessage: error.localizedDescription)
        }
    }
    
    public func copySummary() {
        UIPasteboard.general.string = currentSaveText
    }
    
    @MainActor
    public func doneButtonTapped(withFolder folder: Folder) {
        guard let currentSaveText = currentSaveText else { return }
        let image = getCorrectPlaceholderImage(forScan: scannedResult).pngData()
        let scanToSave = Scan(id: UUID(), title: currentSaveTitle ?? currentSaveText, contentText: currentSaveText, scanDate: scannedResult.scanDate, mainImageData: image)
        
        Task {
            do {
                try await service.saveCurrentScan(scan: scanToSave, folder: folder)
                self.done()
            } catch {
                self.delegate?.renderSaveError(errorMessage: error.localizedDescription, folder: folder)
            }
        }
    }
    
    public func done() {
        self.delegate?.goBack()
        self.doneCompletion()
    }
    
    public func back() {
        print("Back home or scan")
    }
    
    public func getStoredService() -> ScanStorege {
        return self.service.storageClient
    }
}

//Handle store view

extension TextAnalyzerPresenter {
    
    @MainActor
    public func storeButtonTapped() {
        storeViewTapped()
    }
    
    @MainActor
    func handleNewProductFeature(productFeature: ProductFeature) {
        self.currentProductFeature = productFeature
    }
}
