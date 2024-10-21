//
//  SideMenuUIComposer.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 21/10/24.
//

import Foundation
import RestApi
import ScanUI
import SwiftUI


public final class SideMenuUIComposer {
    
    private init() {}
    
    static var sideMenuStore: SideMenuStore?
    
    public static func sideMenuStore(
        isMenuShown: Binding<Bool>,
        didSelectRow: @escaping (MenuRow) -> Void = { _ in }
    ) -> SideMenu {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let menuStore = SideMenuStore()
        let menuService = LocalSideMenuService(resourceBundle: bundle)
        
        if SideMenuUIComposer.sideMenuStore == nil {
            SideMenuUIComposer.sideMenuStore = menuStore
        }
        
        let sideMenuPresenter = SideMenuPresenter(delegate: SideMenuUIComposer.sideMenuStore ?? menuStore, service: menuService, didSelectRow: didSelectRow, bundle: bundle)
        
        let menu = SideMenuView(store: SideMenuUIComposer.sideMenuStore ?? menuStore, presenter: sideMenuPresenter, resourceBundle: bundle)
        
        return SideMenu(isShowing: isMenuShown, content: AnyView(menu))
    }
}
