//
//  TextAnalyzerView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/02/24.
//

import SwiftUI
import Combine


public struct TextAnalyzerView: View {
    
    var presenter: TextAnalyzerPresenter
    @ObservedObject var store: TextAnalyzerStore

    var resourceBundle: Bundle
    
    @State private var toggleIsOn = false

    public init(store: TextAnalyzerStore, presenter: TextAnalyzerPresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            Spacer()
            switch store.state {
            case .loading(let showLoader):
                if showLoader {
                    LoadingView()
                }
            case .error(let message):
                ErrorView(title: "Error", description: message, primaryButtonTitle: "ok", primaryAction: {
                    print("Generic error ok")
                }, secondaryButtonTitle: nil, secondaryAction: nil)
            case .showViewModel:
                VStack {
                    TextEditor(text: $store.viewModel.text)
                                    .foregroundStyle(.subtitle)
                                    .padding()
                    Spacer()
                    HStack(alignment: .center, spacing: 10) {
                        Button {
                            Task(priority: .background) {
                                await presenter.makeTranslation()
                            }
                        } label: {
                            Text("Transalate text")
                        }

                        Toggle("Show Origianl", isOn: $toggleIsOn)
                                    .toggleStyle(.button)
                                    .tint(.mint)
                                    .onChange(of: toggleIsOn) {
                                        if toggleIsOn {
                                            presenter.showOriginalSummary()
                                        } else {
                                            presenter.showModifyText()
                                        }
                                    }
                    }
                }.onChange(of: $store.viewModel.text.wrappedValue) {
                    presenter.updateScannedText(text: store.viewModel.text)
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
        .background(Color.scanBackground)
        .onAppear(perform: {
            
        })
    }
}

#Preview {
    @State var scanStore = ScanStore(state: .loading(show: false))
    
    @State var presenter = ScanPresenter(delegate: scanStore, resultOfScan: { _ in })
    
    return ScanView(store: scanStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
}
