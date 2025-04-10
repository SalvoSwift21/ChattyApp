//
//  SideMenuPresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation
import UIKit

public class SideMenuPresenter: SideMenuPresenterProtocol {
    
    internal var didSelectRow: ((MenuRow) -> Void)?
    internal var resourceBundle: Bundle

    private var service: SideMenuServiceProtocol
    private weak var delegate: SideMenuProtocolDelegate?
    private var currentProductFeature: ProductFeature


    public init(delegate: SideMenuProtocolDelegate,
                service: SideMenuServiceProtocol,
                currentProductFeature: ProductFeature,
                didSelectRow: ((MenuRow) -> Void)?,
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.resourceBundle = bundle
        self.didSelectRow = didSelectRow
        self.currentProductFeature = currentProductFeature
    }
    
    @MainActor
    func loadData() async {
        do {
            let menuSections: [MenuSection]
            if currentProductFeature.features.contains(.removeAds) {
                
                var allSections = try await service.getMenuSections()
                let copy = allSections
                
                copy.enumerated().forEach { index, section in
                    guard let firstIndex =  section.rows.firstIndex(where: { $0.rowType == .premium }) else { return }
                    allSections[index].rows.remove(at: firstIndex)
                }
                menuSections = allSections
                
            } else {
                menuSections = try await service.getMenuSections()
            }
            
            let vModel = SideMenuViewModel(sections: menuSections, topImage: UIImage(named: "side_menu_logo", in: resourceBundle, with: nil))
            self.delegate?.render(viewModel: vModel)
        } catch {
            print("Error \(error.localizedDescription)")
        }
    }
}

//Handle store view

extension SideMenuPresenter {
    
    @MainActor
    func handleNewProductFeature(productFeature: ProductFeature) {
        self.currentProductFeature = productFeature
        Task {
            await self.loadData()
        }
    }
}
