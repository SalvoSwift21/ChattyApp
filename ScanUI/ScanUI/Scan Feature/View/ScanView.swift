//
//  ScanView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import Foundation
import SwiftUI

public struct ScanView: View {
    

    var presenter: ScanPresenter
    @ObservedObject var store: ScanStore

    var resourceBundle: Bundle
    
    public init(store: ScanStore, presenter: ScanPresenter, resourceBundle: Bundle = .main) {
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
            case .loaded(let viewModel):
                VStack(alignment: .center, spacing: 30.0) {
                    Text("Position text within frame, and tap for choose text.")
                    DataScannerView(dataScannerViewController: viewModel.dataScannerController)
                        .cornerRadius(10.0)
                        .padding()
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
            presenter.startScan()
        })
    }
}

#Preview {
    @State var scanStore = ScanStore(state: .loading(show: false))
    
    @State var presenter = ScanPresenter(delegate: scanStore, resultOfScan: { _ in })
    
    return ScanView(store: scanStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
}
