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
    @State private var currentProductSelected = ProductFeature(features: [], productID: "")

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
                    SubscriptionStoreView(productIDs: viewModel.getOnlyPaidModels().map(\.productID), content: {
                        SubscriptionOptionGroupSet { product in
                            return viewModel.products.first(where: { $0.productID == product.id }) ??                             ProductFeature(features: [], productID: "product")
                        } label: { product in
                            Text(product.getLocalizedDescription().title)
                        } marketingContent: { product in
                            PassMarketingContent(product: product, bundle: self.resourceBundle)
                        }
                    })
                    .subscriptionStoreControlStyle(.compactPicker, placement: .bottomBar)
                    .subscriptionStoreOptionGroupStyle(.tabs)
                    .subscriptionStorePickerItemBackground(.backgroundFolder.opacity(0.5))
                    .background(Color.mainBackground)
                    .onInAppPurchaseStart(perform: { product in
                        currentProductSelected = viewModel.getOnlyPaidModels().first(where: { $0.productID == product.id }) ?? ProductFeature(features: [], productID: "")
                    })
                    .onInAppPurchaseCompletion { product, result in
                        presenter.productTapped(productModelID: product.id,
                                                productPurchaseResult: result)
                    }
                    .tint(.prime)
                    .foregroundColor(.title)
                    .onAppear {
                        self.currentProductSelected = viewModel.selectedProduct
                    }
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
        .navigationBarHidden(true)
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
    var resourceBundle: Bundle
    
    init(product: ProductFeature, bundle: Bundle) {
        self.product = product
        self.resourceBundle = bundle
    }
    
    var body: some View {
        
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [Color.backgroundFolder.opacity(0.8), Color.prime.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            
            VStack(spacing: 15) {
                Image("AppIconStoreView", bundle: resourceBundle)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(.circle)
                    
                VStack(spacing: 25) {
                    Text("STORE_VIEW_TITLE")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.title)
                    
                    description
                        .font(.callout.weight(.medium))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.subtitle)
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var title: some View {
        Text(product.getLocalizedDescription().title)
    }
    
    @ViewBuilder
    private var description: some View {
        Text(product.getLocalizedDescription().description)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
    }
    
}

#Preview {
    var storeFeature = StoreFeatureStore()
    var service = ProductFeatureService(resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
    let productFeature = ProductFeature(features: [], productID: "free")
    var presenter = StorePresenter(delegate: storeFeature, service: service, productFeature: productFeature, closeAction: { }) { _ in }
    
    return NavigationView {
        StoreFeatureView(store: storeFeature, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
    }
}
