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
    
    var resourceBundle: Bundle
    var localizationBundle: Bundle
    
    public init(store: OnboardingStore, presenter: OnboardingPresenterProtocol, resourceBundle: Bundle = .main, localizationBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
        self.localizationBundle = localizationBundle
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            Image("main_logo", bundle: resourceBundle)
                .resizable()
                .scaledToFit()
                .frame(width: 172, height: 44, alignment: .center)
            Spacer()
            switch store.state {
            case .loading:
                LoadingView()
            case .error(let message):
                ErrorView(title: "GENERIC_ERROR_TITLE", description: message, primaryButtonTitle: "GENERIC_RELOAD_ACTION", primaryAction: {
                    Task {
                        await presenter.fetchOnboardingsCard()
                    }
                }, secondaryButtonTitle: nil, secondaryAction: nil)
            case .loaded(let cards):
                TabView(selection: $store.currentPage) {
                    ForEach(cards) { card in
                        OnboardingView(onboardingViewModel: card, resourceBundle: resourceBundle, localizationBundle: localizationBundle)
                            .tag(cards.firstIndex(of: card) ?? 0)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.default, value : store.currentPage)
                
                Spacer()
                HStack {
                    PageControl(numberOfPages: store.totalPages, currentPage: $store.currentPage)
                    Spacer()
                    Button(action: store.showCompleteOnboarding ? presenter.completeOnboarding : store.goNext) {
                        Text(store.showCompleteOnboarding ? "Complete" : "Next")
                            .fontWeight(.bold)
                    }
                    .buttonStyle(DefaultButtonStyle(frame: .init(width: 200, height: 57)))
                }
            }
            Spacer()
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

#Preview {
    @State var onboardingStore = OnboardingStore()
    @State var presenter = OnboardingPresenter(service: OnboardingService(), delegate: onboardingStore, completeOnboardingCompletion: { })
    
    return OnboardingContainerView(store: onboardingStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
}
