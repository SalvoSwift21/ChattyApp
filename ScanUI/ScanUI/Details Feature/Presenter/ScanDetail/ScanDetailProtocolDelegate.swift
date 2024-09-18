//
//  UploadFileProtocolos.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation

protocol ScanDetailPresenterProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    func loadData() async
    
    func copyContent()
}

public protocol ScanDetailProtocolDelegate: AnyObject {
    func render(errorMessage: String)
    func renderLoading(visible: Bool)
    func render(viewModel: ScanDetailViewModel)
}
