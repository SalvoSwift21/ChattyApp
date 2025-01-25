//
//  PreferencePresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/23/25.
//


public class StorePresenter: StorePresenterProtocol {
        
    internal var resourceBundle: Bundle

    private var service: ProductFeatureProtocol
    private weak var delegate: StoreDelegate?
    public var menuButton: (() -> Void)


    public init(delegate: StoreDelegate,
                service: ProductFeatureService,
                menuButton: @escaping (() -> Void),
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.menuButton = menuButton
        self.resourceBundle = bundle
    }
    
    @MainActor
    func loadData() async {
        do {
            let products = try await service.getProductFeatures()
            let vModel = StoreViewModel(products: products)
            if products.isEmpty {
                self.delegate?.render(errorMessage: "No products avaible")
            } else {
                self.delegate?.render(viewModel: vModel)
            }
        } catch {
            self.delegate?.render(errorMessage: "No products avaible")
        }
    }
    
    func productTapped(_ productModel: ProductFeature) async throws { }
}
