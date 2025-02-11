//
//  ADUnitIDCode.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 2/9/25.
//


enum ADUnitIDCode {
    case bannerID

    var id: String {
        switch self {
        case .bannerID:
            #if DEBUG
            return "ca-app-pub-3940256099942544/2435281174"
            #else
            return "ca-app-pub-6751063947323511/1625953189"
            #endif
        }
    }
}

