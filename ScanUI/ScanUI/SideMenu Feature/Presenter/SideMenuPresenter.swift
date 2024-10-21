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
    

    public init(delegate: SideMenuProtocolDelegate,
                service: SideMenuServiceProtocol,
                didSelectRow: ((MenuRow) -> Void)?,
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.resourceBundle = bundle
        self.didSelectRow = didSelectRow
    }
    
    @MainActor
    func loadData() async {
        do {
            let menuSections = try await service.getMenuSections()
            let vModel = SideMenuViewModel(sections: menuSections, topImage: UIImage(named: "side_menu_logo", in: resourceBundle, with: nil))
            self.delegate?.render(viewModel: vModel)
        } catch {
            print("Error \(error.localizedDescription)")
        }
    }
}
