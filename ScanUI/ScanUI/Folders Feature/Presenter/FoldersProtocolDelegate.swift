//
//  UploadFileProtocolos.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation

protocol FoldersPresenterProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    var didSelectFolder: ((Folder) -> Void)? { get set }
    var currentProductFeature: ProductFeature { get set }
    var bannerID: String { get set }
    
    func loadData() async
    func createNewFolder(name: String) async
    
    func handleErrorButton()
}

@MainActor
public protocol FoldersProtocolDelegate: AnyObject {
    func render(errorMessage: String?)
    func renderLoading(visible: Bool)
    func render(viewModel: FoldersViewModel)
}
