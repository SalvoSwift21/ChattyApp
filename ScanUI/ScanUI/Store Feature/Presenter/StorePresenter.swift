//
//  PreferencePresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/23/25.
//

import StoreKit


public class StorePresenter: StorePresenterProtocol {
        
    internal var resourceBundle: Bundle

    private var service: ProductFeatureProtocol
    private var productFeature: ProductFeature
    
    private weak var delegate: StoreDelegate?
    public var menuButton: (() -> Void)
    public var productFeatureTapped: ((ProductFeature) -> Void)
    
    private var allProductsFeature: [ProductFeature] = []


    public init(delegate: StoreDelegate,
                service: ProductFeatureService,
                productFeature: ProductFeature,
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main,
                menuButton: @escaping (() -> Void),
                productFeatureTapped: @escaping ((ProductFeature) -> Void)) {
        self.service = service
        self.delegate = delegate
        self.menuButton = menuButton
        self.resourceBundle = bundle
        self.productFeature = productFeature
        self.productFeatureTapped = productFeatureTapped
    }
    
    @MainActor
    func loadData() async {
        do {
            let products = try await service.getProductFeatures()
            //Not used for now
            let sortedProductIDs = products.sorted {
                $0.productID == productFeature.productID ? true : ($1.productID == productFeature.productID ? false : true)
            }
            
            let vModel = StoreViewModel(products: products)
            self.allProductsFeature = products
            if products.isEmpty {
                self.delegate?.render(errorMessage: "No products avaible")
            } else {
                self.delegate?.render(viewModel: vModel)
            }
        } catch {
            self.delegate?.render(errorMessage: "No products avaible")
        }
    }
    
    func productTapped(productModelID: String, productPurchaseResult: Result<Product.PurchaseResult, any Error>) {
        switch productPurchaseResult {
        case .success(let success):
            switch success {
            case .success(_):
                guard let newProductFeature = self.allProductsFeature.first(where: { $0.productID  == productModelID }) else { return }
                productFeatureTapped(newProductFeature)
                productFeature = newProductFeature
            case .pending: break
            case .userCancelled: break
            default: break
            }
        case .failure(let error):
            Task {
                await self.delegate?.render(errorMessage: "L'acquisto non è stato completato")
            }
        }
        refreshView()
    }
    
    func handleErrorButtonTapped() {
        Task {
            await self.delegate?.render(errorMessage: nil)
            await self.loadData()
        }
    }
    
    fileprivate func refreshView() {
        Task {
            await self.loadData()
        }
    }
}
