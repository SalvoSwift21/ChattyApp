//
//  PreferencePresenterProtocol.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 1/23/25.
//


import Foundation

protocol StorePresenterProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    var menuButton: (() -> Void) { get set }

    func loadData() async
    
    func productTapped(_ productModel: ProductModel) async throws
}

public protocol StoreDelegate: AnyObject {
    func render(errorMessage: String)
    func render(viewModel: StoreViewModel)
}
