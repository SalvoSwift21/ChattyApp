//
//  StoreView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/27/25.
//


import Foundation
import SwiftUI
import StoreKit

public struct StoreFeatureView: View {
    
    var presenter: StorePresenter
    @ObservedObject var store: StoreFeatureStore

    var resourceBundle: Bundle

    public init(store: StoreFeatureStore, presenter: StorePresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            switch store.state {
            case .unowned:
                EmptyView()
            case .error(let message):
                ErrorView(title: "Error", description: message, primaryButtonTitle: "Store kit error", primaryAction: {
                    Task {
                        await presenter.loadData()
                    }
                }, secondaryButtonTitle: nil, secondaryAction: nil)
            case .loaded(let viewModel):
                SubscriptionStoreView(
                    productIDs: viewModel.products.map(\.productID)
                )
                .subscriptionStoreButtonLabel(.multiline)
                .subscriptionStoreControlStyle(.automatic)
                .subscriptionStorePickerItemBackground(.backgroundFolder.opacity(0.5))
                .background(Color.mainBackground)
                .onInAppPurchaseCompletion { product, result in
                    presenter.productTapped(productModelID: product.id,
                                            productPurchaseResult: result)
                }
                .tint(.prime)
                .foregroundColor(.title)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button {
                        presenter.menuButton()
                    } label: {
                        Image("menu_icon", bundle: resourceBundle)
                    }
                }
            }
        }
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
    var storeFeature = StoreFeatureStore()
    var service = ProductFeatureService(resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
    let productFeature = ProductFeature(features: [], productID: "free")
    var presenter = StorePresenter(delegate: storeFeature, service: service, productFeature: productFeature, menuButton: { }) { _ in }
    
    return NavigationView {
        StoreFeatureView(store: storeFeature, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
    }
}
