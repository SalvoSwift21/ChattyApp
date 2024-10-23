//
//  AIPreferenceModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 22/10/24.
//

import Foundation


public struct AIPreferenceModel: Codable {
    var id: UUID = UUID()

    var title: String
    var imageName: String
    public var aiType: AIPreferenceType
    
    public init(title: String, imageName: String, aiType: AIPreferenceType) {
        self.title = title
        self.imageName = imageName
        self.aiType = aiType
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case imageName
        case aiType
    }
}

public enum AIPreferenceType: String, CaseIterable, Codable {
    case gpt_3_5 = "gpt-3.5"
    case gemini_1_5_flash = "gemini-1.5-flash"
    case gemini_pro = "gemini-pro"
    
    case unowned
    
    func getDescription() -> String {
        switch self {
        case .gpt_3_5:
            "Riassunti chiari e veloci per qualsiasi testo."
        case .gemini_1_5_flash:
            "Riassunti istantanei e precisi, ottimizzati per la velocità."
        case .gemini_pro:
            "Riassunti personalizzati e dettagliati, su misura per le tue esigenze."
        case .unowned:
            "Error"
        }
    }
}
