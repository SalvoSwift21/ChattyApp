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
            Image("main_logo", bundle: .init(identifier: "com.ariel.ScanUI"))
                .resizable()
                .scaledToFit()
                .frame(width: 172, height: 44, alignment: .center)
            Spacer()
            switch store.state {
            case .loading:
                AnyView(Text("sto caricando"))
            case .error(let message):
                AnyView(Text("Errore \(message)"))
            case .loaded(let cards):
                TabView(selection: $store.currentPage) {
                    ForEach(cards) { card in
                        OnboardingView(onboardingViewModel: card)
                            .tag(cards.firstIndex(of: card) ?? 0)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.default, value : store.currentPage)

                Spacer()
                HStack {
                    PageControl(numberOfPages: store.totalPages, currentPage: $store.currentPage)
                    Button(action: store.showCompleteOnboarding ? presenter.completeOnboarding : store.goNext) {
                        Text(store.showCompleteOnboarding ? "Complete" : "Next")
                            .fontWeight(.bold)
                    }
                    .buttonStyle(DefaultButtonStyle(frame: .init(width: 200, height: 57)))
                }.padding()
            }
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(.mainBackground)
        .task(presenter.fetchOnboardingsCard)
    }
}

struct OnboardingView: View {
    var onboardingViewModel: OnboardingViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image(onboardingViewModel.image, bundle: .init(identifier: "com.ariel.ScanUI"))
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

#Preview {
    @State var onboardingStore = OnboardingStore()
    @State var presenter = OnboardingPresenter(service: OnboardingService(), delegate: onboardingStore)
    
    return OnboardingContainerView(store: onboardingStore, presenter: presenter)
}
