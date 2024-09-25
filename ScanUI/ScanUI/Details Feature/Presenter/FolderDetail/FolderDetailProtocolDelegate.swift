//
//  UploadFileProtocolos.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation

protocol FolderDetailPresenterProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    func loadData() async
    
    func select(scan: Scan)
}

public protocol FolderDetailProtocolDelegate: AnyObject {
    func render(errorMessage: String)
    func renderLoading(visible: Bool)
    func render(viewModel: FolderDetailViewModel)
    
    func select(scan: Scan)
}
