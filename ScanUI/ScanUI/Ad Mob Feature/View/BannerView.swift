//
//  BannerView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 2/9/25.
//

import SwiftUI
import GoogleMobileAds


struct ExternalBannerView: View {
    
    var addUnitID: String
    @State private var adSize: AdSize
    
    init(addUnitID: String) {
        self.addUnitID = addUnitID
        self.adSize = currentOrientationAnchoredAdaptiveBanner(width: UIScreen.main.bounds.width)
    }
    
    var body: some View {
        BannerViewContainer(addUnitID: addUnitID, adSize: adSize)
            .frame(width: adSize.size.width, height: adSize.size.height)
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: {
                self.adSize = currentOrientationAnchoredAdaptiveBanner(width: $0.width)
            }
    }
}

private struct BannerViewContainer: UIViewRepresentable {
    
    let adSize: AdSize
    let addUnitID: String
    
    init(addUnitID: String, adSize: AdSize) {
        self.addUnitID = addUnitID
        self.adSize = adSize
    }
    
    func makeUIView(context: Context) -> UIView {
        // Wrap the GADBannerView in a UIView. GADBannerView automatically reloads a new ad when its
        // frame size changes; wrapping in a UIView container insulates the GADBannerView from size
        // changes that impact the view returned from makeUIView.
        let view = UIView()
        view.addSubview(context.coordinator.bannerView)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.bannerView.adSize = adSize
    }
    
    func makeCoordinator() -> BannerCoordinator {
        return BannerCoordinator(self)
    }
    
    class BannerCoordinator: NSObject, BannerViewDelegate {
        
        private(set) lazy var bannerView: BannerView = {
            let banner = BannerView(adSize: parent.adSize)
            banner.adUnitID = parent.addUnitID
            banner.delegate = self
            banner.load(Request())
            return banner
        }()
        
        let parent: BannerViewContainer
        
        init(_ parent: BannerViewContainer) {
            self.parent = parent
        }
        
        fileprivate func bannerViewDidReceiveAd(_ bannerView: BannerView) {
          print("bannerViewDidReceiveAd")
        }

        fileprivate func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
          print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        }

        fileprivate func bannerViewDidRecordImpression(_ bannerView: BannerView) {
          print("bannerViewDidRecordImpression")
        }

        fileprivate func bannerViewWillPresentScreen(_ bannerView: BannerView) {
          print("bannerViewWillPresentScreen")
        }

        fileprivate func bannerViewWillDismissScreen(_ bannerView: BannerView) {
          print("bannerViewWillDIsmissScreen")
        }

        fileprivate func bannerViewDidDismissScreen(_ bannerView: BannerView) {
          print("bannerViewDidDismissScreen")
        }
    }
}
