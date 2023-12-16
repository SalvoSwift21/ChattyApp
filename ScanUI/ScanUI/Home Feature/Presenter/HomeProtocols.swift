//
//  HomeProtocols.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 12/12/23.
//

import Foundation

public protocol HomePresenterProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    func getSearchResult(for query: String) async
    @Sendable func getHome() async
    func uploadImage()
    func newScan()
}

public protocol HomePresenterDelegate: AnyObject {
    func render(errorMessage: String)
    func renderLoading(visible: Bool)
    func render(viewModel: HomeViewModel)
}
