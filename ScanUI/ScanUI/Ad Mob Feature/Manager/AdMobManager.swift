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
    
    public init(bannerUnitId: String) {
        self.bannerUnitId = bannerUnitId
    }
    
    public func startManager() async throws {
        await MobileAds.shared.start()
    }
    
    public func getBannerUnitId() -> String {
        return self.bannerUnitId
    }
}
