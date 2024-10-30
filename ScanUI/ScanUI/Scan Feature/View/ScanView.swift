//
//  ScanView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import Foundation
import SwiftUI

public struct ScanView: View {
    
    @Environment(\.dismiss) var dismiss

    var presenter: ScanPresenter
    @ObservedObject var store: ScanStore

    var resourceBundle: Bundle
    
    public init(store: ScanStore, presenter: ScanPresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            switch store.state {
            case .loading(let showLoader):
                if showLoader {
                    LoadingView()
                }
            case .error(let message):
                VStack(alignment: .center, content: {
                    Spacer()
                    ErrorView(title: "Error", description: message, primaryButtonTitle: "ok", primaryAction: {
                        presenter.goBack()
                    }, secondaryButtonTitle: nil, secondaryAction: nil)
                    Spacer()
                }).padding()
            case .loaded(let viewModel):
                DataScannerView(dataScannerViewController: viewModel.dataScannerController)
                VStack {
                    ZStack(alignment: .center, content: {
                        Color.black.opacity(0.4)
                            .frame(height: 120, alignment: .center)
                        HStack(alignment: .top, content: {
                            Button(action: {
                                presenter.goBack()
                            }, label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .foregroundStyle(.buttonTitle)
                            })
                            .padding()
                            Spacer()
                        })
                        .padding(.top, 10)
                        .padding(.horizontal, 8)
                    })
                    Spacer()
                    ZStack(alignment: .top, content: {
                        Color.black.opacity(0.4)
                            .frame(height: 120, alignment: .center)
                        Text("Position text within frame, and tap for choose text.")
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 20))
                            .fontWeight(.regular)
                            .foregroundStyle(.buttonTitle)
                            .padding(.vertical)
                    })
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .ignoresSafeArea()
        .onAppear(perform: {
            presenter.startScan()
        })
        .onChange(of: store.back) {
            if store.back {
                self.dismiss()
            }
        }
    }
}

#Preview {
    @State var scanStore = ScanStore(state: .loading(show: false))
    
    @State var presenter = ScanPresenter(delegate: scanStore, resultOfScan: { _ in })
    
    return ScanView(store: scanStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
}
