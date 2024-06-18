//
//  HomeProtocols.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 12/12/23.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    var uploadImage: (() -> Void) { get set }
    var newScan: (() -> Void) { get set }
    var sellAllButton: (() -> Void) { get set }
    var scanTapped: ((Scan) -> Void) { get set }

    func loadData() async
    
    func getSearchResult(for query: String) async
    func getHome() async throws -> HomeViewModel
    func createNewFolder(name: String) async
}

public protocol HomePresenterDelegate: AnyObject {
    func render(errorMessage: String)
    func renderLoading(visible: Bool)
    func render(viewModel: HomeViewModel)
}
