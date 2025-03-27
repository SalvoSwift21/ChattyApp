//
//  ChatCellViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 17/06/24.
//

import Foundation
import SwiftUI

public enum ChatPosition {
    case left, right, full
}

public class ChatCellViewModel: ObservableObject {
    var uuid: UUID = UUID()
    
    var title: LocalizedStringKey?
    @Published var description: String?
    var image: UIImage?
    
    var backgroundColor: Color
    var position: ChatPosition = .left
    
    @Published var isInLoading: Bool
    
    public init(title: String? = nil, description: String? = nil, image: UIImage? = nil, backgroundColor: Color, position: ChatPosition = .left, isInLoading: Bool) {
        self.title = title == nil ? nil : LocalizedStringKey(title ?? "")
        self.description = description
        self.image = image
        self.backgroundColor = backgroundColor
        self.position = position
        self.isInLoading = isInLoading
    }
}
