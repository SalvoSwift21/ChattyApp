//
//  UserMessagubgPlatformManager.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 3/22/25.
//

import Foundation
import UserMessagingPlatform


public class UserMessagubgPlatformManager {
    
    var canRequestAds: Bool {
      return UMPConsentInformation.sharedInstance.canRequestAds
    }

    var isPrivacyOptionsRequired: Bool {
      return UMPConsentInformation.sharedInstance.privacyOptionsRequirementStatus == .required
    }
    
    public init() { }
    
    @MainActor
    public func askConsentInfo() async throws {
        let parameters = UMPRequestParameters()
        let debugSettings = UMPDebugSettings()

        debugSettings.testDeviceIdentifiers = ["TEST-DEVICE-HASHED-ID"]
        parameters.debugSettings = debugSettings
        
        try await UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters)
        try await UMPConsentForm.loadAndPresentIfRequired(from: nil)
    }
    
    /// Helper method to call the UMP SDK method to present the privacy options form.
    @MainActor
    func presentPrivacyOptionsForm() async throws {
        try await UMPConsentForm.presentPrivacyOptionsForm(from: nil)
    }
}
