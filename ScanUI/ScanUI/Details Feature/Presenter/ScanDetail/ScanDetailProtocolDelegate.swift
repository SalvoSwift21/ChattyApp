//
//  UploadFileProtocolos.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation

protocol ScanDetailPresenterProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    var currentProductFeature: ProductFeature { get set }
    var bannerID: String { get set }
    
    func loadData() async
    
    func copyContent()
    
    func showADBanner() -> Bool
}

public protocol ScanDetailProtocolDelegate: AnyObject {
    func render(errorMessage: String?)
    func renderLoading(visible: Bool)
    func render(viewModel: ScanDetailViewModel)
}
