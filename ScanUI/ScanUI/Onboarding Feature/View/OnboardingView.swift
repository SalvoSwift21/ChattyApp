//
//  OnboardingView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 27/11/23.
//

import SwiftUI

struct OnboardingView: View {
  var presenter: OnboardingPresenterProtocol
  @ObservedObject var store: OnboardingStore

  init(store: OnboardingStore, presenter: OnboardingPresenterProtocol) {
    self.store = store
    self.presenter = presenter
  }

  var body: some View {
    NavigationView { () -> AnyView in
      switch store.state {
      case .loading:
          return AnyView(Text("sto caricando"))
      case .error(let message):
          return AnyView(Text("Errore \(message)"))
      case .loaded(let cards):
          if cards.isEmpty {
              return AnyView(Text("Non ci sono cards"))
          } else {
              return AnyView(Text("ci sono le card cerca di mostrare qualcosa idiota"))
        }
      }
    }.task(presenter.fetchOnboardingsCard)
  }
}

