//
//  OnboardingView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 27/11/23.
//

import SwiftUI

public struct OnboardingContainerView: View {
    var presenter: OnboardingPresenterProtocol
    @ObservedObject var store: OnboardingStore
    
    public init(store: OnboardingStore, presenter: OnboardingPresenterProtocol) {
        self.store = store
        self.presenter = presenter
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            Image("main_logo", bundle: .main)
                .resizable()
                .frame(alignment: .center)
            switch store.state {
            case .loading:
                AnyView(Text("sto caricando"))
            case .error(let message):
                AnyView(Text("Errore \(message)"))
            case .loaded(let cards):
                TabView {
                    ForEach(cards) { card in
                        OnboardingView(onboardingViewModel: card)
                    }
                }
            }
            HStack {
                Text("il selettore")
                Button(action: presenter.goNext) {
                    Text("Next")
                        .fontWeight(.bold)
                        .foregroundStyle(.buttonTitle)
                }
                .padding()
                .background(Color.primary)
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .background(.mainBackground)
        .task(presenter.fetchOnboardingsCard)
    }
}

struct OnboardingView: View {
    var onboardingViewModel: OnboardingViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image(onboardingViewModel.image)
            VStack(alignment: .leading, spacing: 10) {
                Text(onboardingViewModel.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.title)
                Text(onboardingViewModel.subtitle)
                    .fontWeight(.regular)
                    .foregroundStyle(.subtitle)
            }
        }
    }
}


