//
//  AIPreferenceModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 22/10/24.
//

import Foundation
import UniformTypeIdentifiers
import LLMFeature
import OpenAIFeature
import GoogleAIFeature

public struct AIPreferenceModel: Codable {
    var id: UUID = UUID()

    var title: String
    var imageName: String
    public var aiType: AIModelType
    
    public init(title: String, imageName: String, aiType: AIModelType) {
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

public enum AIModelType: String, CaseIterable, Codable {
    case gpt_4_o = "gpt-4o"
    case gpt_4o_mini = "gpt-4o-mini"
    case gemini_1_5_flash = "gemini-1.5-flash"
    case gemini_1_5_flash_8b = "gemini-1.5-flash-8b"
    case gemini_pro = "gemini-1.5-pro"
    
    case unowned
    
    func getDescription() -> String {
        switch self {
        case .gpt_4_o:
            return "AI_MODEL_DESCRIPTION_GPT4_O"
        case .gpt_4o_mini:
            return "AI_MODEL_DESCRIPTION_GPT4_O_MINI"
        case .gemini_1_5_flash:
            return "AI_MODEL_DESCRIPTION_GEMINI_1.5_FLASH"
        case .gemini_pro:
            return "AI_MODEL_DESCRIPTION_GEMINI_PRO"
        case .gemini_1_5_flash_8b:
            return "AI_MODEL_DESCRIPTION_GEMINI_1.5FLASH_8B"
        case .unowned:
            return "Error"
        }
    }
    
    public func getAISupportedFileTypes() -> [UTType] {
        switch self {
            case .gpt_4_o, .gpt_4o_mini:
            return OpenAiConfiguration.getSupportedUTType()
        case .gemini_1_5_flash, .gemini_1_5_flash_8b, .gemini_pro:
            return GoogleAIConfigurations.getSupportedUTType()
        default:
            return []
        }
    }
    
    public func getAllSupportedLanguages() throws -> LLMSuppotedLanguages {
        switch self {
        case .gpt_4_o, .gpt_4o_mini:
            return try OpenAiConfiguration.getSupportedLanguages()
        case .gemini_1_5_flash, .gemini_1_5_flash_8b, .gemini_pro, .unowned:
            return try GoogleAIConfigurations.getSupportedLanguages()
        }
    }
    
    public func isEnabledFor(productID: String) -> Bool {
        var licenseType: [String] = []
        
        switch self {
        case .gpt_4_o:
            licenseType = ["pro_monthly"]
        case .gpt_4o_mini:
            licenseType = ["free", "base_monthly", "pro_monthly"]
        case .gemini_1_5_flash:
            licenseType = ["free", "base_monthly", "pro_monthly"]
        case .gemini_1_5_flash_8b:
            licenseType = ["base_monthly", "pro_monthly"]
        case .gemini_pro:
            licenseType = ["pro_monthly"]
        case .unowned:
            break
        }
        
        return licenseType.contains(where: { $0 == productID })
    }
}
