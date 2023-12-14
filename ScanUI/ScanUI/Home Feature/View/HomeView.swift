//
//  HomeView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 12/12/23.
//

import SwiftUI
import RestApi

public struct HomeView: View {
    var presenter: HomePresenter
    @ObservedObject var store: HomeStore
    
    var resourceBundle: Bundle
    
    public init(store: HomeStore, presenter: HomePresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            HStack {
                Button("menu") {
                    
                }
                Image("main_logo", bundle: resourceBundle)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 20, alignment: .leading)
                Spacer()
            }
            Spacer()
            switch store.state {
            case .loading(let showLoader):
                if showLoader {
                    LoadingView()
                }
            case .error(let message):
                ErrorView(title: "Error", description: message, primaryButtonTitle: "Reload home", primaryAction: {
                    
                }, secondaryButtonTitle: nil, secondaryAction: nil)
            case .loaded(let viewModel):
                Spacer()
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(alignment: .leading, spacing: 32, content: {
                        HomeMyFoldesView(resourceBundle: resourceBundle, folders: viewModel.myFolders)
                        HomeMyRecentScanView(resourceBundle: resourceBundle, scans: viewModel.recentScans ?? [])
                    })
                })
            }
            Spacer()
            HStack {
                Button {
                    presenter.uploadImage()
                } label: {
                    Text("upload image")
                }
                Button {
                    presenter.newScan()
                } label: {
                    Text("Start new scan")
                }
                Spacer()
            }
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(.mainBackground)
        .task(presenter.getHome)
    }
}

#Preview {
    @State var homeStore = HomeStore()
    var homeService = HomeService(client: URLSessionHTTPClient(session: URLSession(configuration: URLSessionConfiguration.default)))
    @State var presenter = HomePresenter(service: homeService, delegate: homeStore)
    
    return HomeView(store: homeStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
}
