//
//  SideMenuProtocolDelegate.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation

protocol SideMenuPresenterProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    var didSelectRow: ((MenuRow) -> Void)? { get set }

    func loadData() async 
}

public protocol SideMenuProtocolDelegate: AnyObject {
    func render(viewModel: SideMenuViewModel)
}
