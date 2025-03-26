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
        ZStack {
            VStack(alignment: .center) {
                switch store.state {
                case .unowned:
                    EmptyView()
                case .loaded(let viewModel):
                    SubscriptionStoreView(productIDs: viewModel.getOnlyPaidModels().map(\.productID), marketingContent: {
                        VStack {
                            ForEach(viewModel.getOnlyPaidModels(), id: \.productID) { element in
                                PassMarketingContent(product: element)
                                    .padding()
                            }
                        }
                    })
                    .subscriptionStoreButtonLabel(.multiline)
                    .subscriptionStoreControlStyle(.prominentPicker)
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
            
            if let errorMessage = store.errorMessage {
                Color
                    .scanBackground
                    .opacity(0.15)
                    .ignoresSafeArea(.all)
                
                ErrorView(title: "GENERIC_ERROR_TITLE", description: errorMessage, primaryButtonTitle: "GENERIC_RELOAD_ACTION", primaryAction: {
                    presenter.handleErrorButtonTapped()
                }, secondaryButtonTitle: nil, secondaryAction: nil)
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
        .navigationTitle("Scanny Pass")
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

private struct PassMarketingContent: View {
    var product: ProductFeature
    
    init(product: ProductFeature) {
        self.product = product
    }
    
    var body: some View {
        VStack(spacing: 10) {
            title
                .font(.title3.bold())
                .foregroundStyle(.title)
            
            description
                .fixedSize(horizontal: false, vertical: true)
                .font(.body.weight(.medium))
                .multilineTextAlignment(.leading)
                .foregroundStyle(.subtitle)
                .padding([.bottom, .horizontal])
        }
        .padding()
        .background(.backgroundFolder.opacity(0.5))
        .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    private var subscriptionName: some View {
        Text("Backyard Birds Pass")
    }
    
    @ViewBuilder
    private var title: some View {
        Text(product.getLocalizedDescription().title)
    }
    
    @ViewBuilder
    private var description: some View {
        Text(product.getLocalizedDescription().description)
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
