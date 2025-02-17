//
//  InterstitialViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 2/11/25.
//

import GoogleMobileAds

class InterstitialViewModel: NSObject, FullScreenContentDelegate {
    
    private var interstitialAd: InterstitialAd?
    private var id: String
    
    init(id: String) {
        self.id = id
    }
    
    func loadAd() async {
        do {
            interstitialAd = try await InterstitialAd.load(
                with: id, request: Request())
            interstitialAd?.fullScreenContentDelegate = self
        } catch {
            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
        }
    }
    
    func showAd() {
        guard let interstitialAd = interstitialAd else {
            return print("Ad wasn't ready.")
        }
        
        interstitialAd.present(from: nil)
    }
    
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func ad(
        _ ad: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        print("\(#function) called")
    }
    
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("\(#function) called")
        // Clear the interstitial ad.
        interstitialAd = nil
    }
}
