//
//  RootUI.swift
//  
//
//  Created by Salvatore Milazzo on 18/12/23.
//

import Foundation

final class AppRootManager: ObservableObject {
    
    @Published var currentRoot: aiAppRoots = .home
    
    enum aiAppRoots {
        case onboarding
        case home
    }
}
