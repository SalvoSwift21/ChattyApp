//
//  TextAnalyzerViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation

public struct TextAnalyzerViewModel {
    
    var chatHistory: [ChatCellViewModel] = []
    
    public init(chatHistory: [ChatCellViewModel] = []) {
        self.chatHistory = chatHistory
    }
}
