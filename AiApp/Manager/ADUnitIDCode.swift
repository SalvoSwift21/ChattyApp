//
//  ADUnitIDCode.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 2/9/25.
//

import Foundation

enum ADUnitIDCode {
    case bannerID
    case interstitialID

    var id: String {
        switch self {
        case .bannerID:
            #if DEBUG
            return "ca-app-pub-3940256099942544/2435281174"
            #else
            return "ca-app-pub-6751063947323511/7641282298"
            #endif
        case .interstitialID:
            #if DEBUG
            return "ca-app-pub-3940256099942544/4411468910"
            #else
            return "ca-app-pub-6751063947323511/5433104749"
            #endif
        }
    }
}


enum Links {
    case privacyPolicy
    case termsAndConditions
    
    var url: URL {
        switch self {
        case .privacyPolicy:
            return URL(string: "https://www.iubenda.com/privacy-policy/53826001")!
        case .termsAndConditions:
            return URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!
        }
    }
}
