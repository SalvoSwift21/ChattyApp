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
    var maxOutputToken: Int
    var maxInputToken: Int
    
    public init(title: String, imageName: String, aiType: AIModelType, maxOutputToken: Int, maxInputToken: Int) {
        self.title = title
        self.imageName = imageName
        self.aiType = aiType
        self.maxInputToken = maxInputToken
        self.maxOutputToken = maxOutputToken
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case imageName
        case aiType
        case maxOutputToken = "max_output_token"
        case maxInputToken = "max_input_token"
    }
}

public enum AIModelType: String, CaseIterable, Codable {
    case gpt_4_o = "chatgpt-4o-latest"
    case gpt_4o_mini = "gpt-4o-mini"
    case gemini_2_0_flash = "gemini-2.0-flash"
    case gemini_2_0_flash_lite = "gemini-2.0-flash-lite"
    case gemini_pro = "gemini-2.0-pro-exp-02-05"
    
    case unowned
    
    func getDescription() -> String {
        switch self {
        case .gpt_4_o:
            return "AI_MODEL_DESCRIPTION_GPT4_O"
        case .gpt_4o_mini:
            return "AI_MODEL_DESCRIPTION_GPT4_O_MINI"
        case .gemini_2_0_flash:
            return "AI_MODEL_DESCRIPTION_GEMINI_1.5_FLASH"
        case .gemini_pro:
            return "AI_MODEL_DESCRIPTION_GEMINI_PRO"
        case .gemini_2_0_flash_lite:
            return "AI_MODEL_DESCRIPTION_GEMINI_1.5FLASH_8B"
        case .unowned:
            return "Error"
        }
    }
    
    public func getAISupportedFileTypes(forProductFeature productFeature: ProductFeature) -> [UTType] {
        switch self {
            case .gpt_4_o, .gpt_4o_mini:
            return OpenAiConfiguration.getSupportedUTType()
        case .gemini_2_0_flash, .gemini_2_0_flash_lite, .gemini_pro:
            if productFeature.features.contains(where: { $0.rawValue == FeatureEnum.removeAds.rawValue }) {
                return GoogleAIConfigurations.getSupportedUTType()
            } else {
                return [.image, .png, .jpeg]
            }
        default:
            return []
        }
    }
    
    public func getAllSupportedLanguages() throws -> LLMSuppotedLanguages {
        switch self {
        case .gpt_4_o, .gpt_4o_mini:
            return try OpenAiConfiguration.getSupportedLanguages()
        case .gemini_2_0_flash, .gemini_2_0_flash_lite, .gemini_pro, .unowned:
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
        case .gemini_2_0_flash:
            licenseType = ["free", "base_monthly", "pro_monthly"]
        case .gemini_2_0_flash_lite:
            licenseType = ["base_monthly", "pro_monthly"]
        case .gemini_pro:
            licenseType = ["pro_monthly"]
        case .unowned:
            break
        }
        
        return licenseType.contains(where: { $0 == productID })
    }
}
