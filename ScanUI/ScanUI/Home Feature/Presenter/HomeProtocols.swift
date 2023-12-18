//
//  HomeProtocols.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 12/12/23.
//

import Foundation

public protocol HomePresenterProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    var uploadImage: (() -> Void) { get set }
    var newScan: (() -> Void) { get set }

    func getSearchResult(for query: String) async
    @Sendable func getHome() async
}

public protocol HomePresenterDelegate: AnyObject {
    func render(errorMessage: String)
    func renderLoading(visible: Bool)
    func render(viewModel: HomeViewModel)
}