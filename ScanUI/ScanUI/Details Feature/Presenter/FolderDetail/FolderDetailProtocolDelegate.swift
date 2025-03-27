//
//  UploadFileProtocolos.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation

protocol FolderDetailPresenterProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    var currentProductFeature: ProductFeature { get set }
    var bannerID: String { get set }
    
    func loadData() async
    
    func select(scan: Scan)
    func delete(scan: Scan) async throws
    
    func handlePrimaryErrorButton()
    func handleSecondaryErrorButton()
}

@MainActor
public protocol FolderDetailProtocolDelegate: AnyObject {
    func render(errorMessage: String?)
    func renderLoading(visible: Bool)
    func render(viewModel: FolderDetailViewModel)
    
    func select(scan: Scan)
}
