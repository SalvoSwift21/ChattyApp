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
    case gpt_4_o = "gpt-4o"
    case gpt_4o_mini = "gpt-4o-mini"
    case gemini_1_5_flash = "gemini-1.5-flash"
    case gemini_pro = "gemini-1.5-pro"
    
    case unowned
    
    func getDescription() -> String {
        switch self {
        case .gpt_4_o:
            return "Il modello di linguaggio più avanzato, offre riassunti estremamente dettagliati e accurati, catturando le sfumature più complesse del testo. Ideale per analisi approfondite e comprensione a livello umano."
        case .gpt_4o_mini:
            return "Una versione più leggera di GPT-4, offre riassunti concisi e pertinenti, mantenendo un alto livello di qualità. Perfetto per un'analisi rapida ed efficace."
        case .gemini_1_5_flash:
            return "Riassunti istantanei e precisi, ottimizzati per la velocità. Ideale per un'analisi rapida di grandi volumi di testo."
        case .gemini_pro:
            return "Riassunti personalizzati e dettagliati, su misura per le tue esigenze. Offre un'ampia gamma di opzioni di personalizzazione per soddisfare le tue richieste specifiche."
        case .unowned:
            return "Error"
        }
    }}
