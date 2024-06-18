//
//  UploadFileView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import SwiftUI

public struct ScanDetailView: View {
    
    var presenter: ScanDetailPresenter
    @ObservedObject var store: ScanDetailStore

    var resourceBundle: Bundle
    
    public init(store: ScanDetailStore, presenter: ScanDetailPresenter, resourceBundle: Bundle = .main) {
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
                ErrorView(title: "Error", description: message, primaryButtonTitle: "Reload view", primaryAction: {
                    Task {
                        await presenter.loadData()
                    }
                }, secondaryButtonTitle: nil, secondaryAction: nil)
            case .loaded(let viewModel):
                ScrollView {
                    Text("Sono ioooo")
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
        .background(.clear)
        .task {
            await presenter.loadData()
        }
    }
}

#Preview {
    
    let scan = Scan(title: "Test scan title",
                    scanDate: .now,
                    mainImage: UIImage(named: "default_scan", in: Bundle(identifier: "com.ariel.ScanUI"), with: nil))
    @State var scanDetailStore = ScanDetailStore(state: .loaded(viewModel: ScanDetailViewModel(scan: scan)))
    var service = ScanDetailService(scan: scan)

    @State var presenter = ScanDetailPresenter(delegate: scanDetailStore, service: service)
    
    return ScanDetailView(store: scanDetailStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
}
