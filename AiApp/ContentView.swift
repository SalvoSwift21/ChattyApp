//
//  ContentView.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 25/05/23.
//

import SwiftUI
import ScanUI

struct ContentView: View {
    let store = OnboardingStore()
    let onboardingPresent: OnboardingPresenter
    
    init() {
        onboardingPresent = OnboardingPresenter(service: OnboardingService(), delegate: self.store)
    }
    
    var body: some View {
        OnboardingContainerView(store: store, presenter: onboardingPresent)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
