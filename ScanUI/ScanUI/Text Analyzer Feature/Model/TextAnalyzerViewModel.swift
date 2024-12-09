//
//  TextAnalyzerViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation
import SwiftUI
import CoreTransferable

public struct TextAnalyzerViewModel {
    
    var chatHistory: [ChatCellViewModel] = []
    
    public init(chatHistory: [ChatCellViewModel] = []) {
        self.chatHistory = chatHistory
    }
    
    func getSharableObject() -> TextAnalyzerSharableModel {
        let image = Image(uiImage: chatHistory.first?.image ?? UIImage())
        let text = chatHistory.last?.description ?? ""
        return TextAnalyzerSharableModel(image: image, description: text)
    }
}

struct TextAnalyzerSharableModel: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.description)
    }

    public var image: Image
    public var description: String
}
