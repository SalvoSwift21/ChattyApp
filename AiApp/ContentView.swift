//
//  ContentView.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 25/05/23.
//

import SwiftUI
import ScanUI
import RestApi

struct ContentView: View {
    let store = OnboardingStore()
    let onboardingPresent: OnboardingPresenter
    
    let homeStore = HomeStore()
    let homePresenter: HomePresenter
    
    init() {
        onboardingPresent = OnboardingPresenter(service: OnboardingService(), delegate: self.store)
        
        let client = URLSessionHTTPClient(session: .init(configuration: .ephemeral))
        
        homePresenter = HomePresenter(service: HomeService(client: client), delegate: self.homeStore)
    }
    
    var body: some View {
        //OnboardingContainerView(store: store, presenter: onboardingPresent, resourceBundle: .init(identifier: "com.ariel.ScanUI") ?? .main)
        
        HomeView(store: homeStore, presenter: homePresenter, resourceBundle: .init(identifier: "com.ariel.ScanUI") ?? .main)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
