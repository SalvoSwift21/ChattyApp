//
//  AdMobManager.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 2/9/25.
//

import Foundation
import GoogleMobileAds

public class AdMobManager: ObservableObject {
    
    var bannerUnitId: String
    var interstitialUnitId: String
    
    public init(bannerUnitId: String, interstitialUnitId: String) {
        self.bannerUnitId = bannerUnitId
        self.interstitialUnitId = interstitialUnitId
    }
    
    public func startManager() async throws {
        await MobileAds.shared.start()
    }
    
    public func getBannerUnitId() -> String {
        return self.bannerUnitId
    }
    
    public func getInterstitialUnitId() -> String {
        return self.interstitialUnitId
    }
}
