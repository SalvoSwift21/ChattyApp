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
            case .loaded(let viewModel):
                DataScannerView(dataScannerViewController: viewModel.dataScannerController)
                VStack {
                    ZStack(alignment: .bottom, content: {
                        bannerBackground
                        ZStack(alignment: .center, content: {
                            HStack(alignment: .center, content: {
                                Button(action: {
                                    presenter.goBack()
                                }, label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 15, height: 15, alignment: .center)
                                        .foregroundStyle(.buttonTitle)
                                })
                                .padding(.bottom, 10)

                                Spacer()
                                
                                Text("SCAN_INFO_TITLE")
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 16))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.buttonTitle)
                                    .padding(.top, 6)
                                
                                Spacer()
                            })
                            .padding()
                        })
                    })
                    Spacer()
                    ZStack(alignment: .top, content: {
                        bannerBackground
                        HStack(alignment: .center, spacing: 0) {
                            shutterButton
                                .disabled(!store.scanButtonEnabled)
                        }
                    })
                }
            }
            
            if let errorMessage = store.errorMessage {
                VStack {
                    Spacer()
                    ErrorView(title: "GENERIC_ERROR_TITLE", description: errorMessage, primaryButtonTitle: "GENERIC_BACK_ACTION", primaryAction: {
                        presenter.goBack()
                    }, secondaryButtonTitle: nil, secondaryAction: nil)
                    Spacer()
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
    
    var bannerBackground: some View {
        Color.prime.opacity(0.5)
            .frame(height: 120, alignment: .center)
    }
    
    
    var shutterButton: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 6)
                .foregroundColor(.white)
                .frame(width: 65, height: 65)
            
            Button {
                presenter.shutterButtonTapped()
            } label: {
                RoundedRectangle(cornerRadius: self.innerCircleWidth / 2)
                    .foregroundColor(.white)
                    .frame(width: self.innerCircleWidth, height: self.innerCircleWidth)
            }
        }
        .animation(.linear, value: 0.5)
        .padding(20)
    }

    var innerCircleWidth: CGFloat {
         55
    }
}

#Preview {
    @State var scanStore = ScanStore(state: .loading(show: false))
    @State var presenter = ScanPresenter(delegate: scanStore, resultOfScan: { _ in })
    
    return ScanView(store: scanStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
}
