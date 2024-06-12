//
//  TextAnalyzerViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 08/02/24.
//

import Foundation
import UIKit
import SwiftUI


public struct TextAnalyzerViewModel {
    
    var chatHistory: [ChatCellViewModel] = []
    
    public init(chatHistory: [ChatCellViewModel] = []) {
        self.chatHistory = chatHistory
    }
}

public enum ChatPosition {
    case left, right
}

public struct ChatCellViewModel {
    var uuid: UUID = UUID()
    
    var title: String?
    var description: String?
    var image: UIImage?
    
    var backgroundColor: Color
    var position: ChatPosition = .left
    
    public init(title: String? = nil, description: String? = nil, image: UIImage? = nil, backgroundColor: Color, position: ChatPosition = .left) {
        self.title = title
        self.description = description
        self.image = image
        self.backgroundColor = backgroundColor
        self.position = position
    }
}
