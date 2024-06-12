//
//  UploadFileProtocolos.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation

protocol FoldersPresenterProtocol: AnyObject {
    var resourceBundle: Bundle { get set }
    var didSelectFolder: ((Folder) -> Void) { get set }

    func loadData() async
    func createNewFolder(name: String) async
}

public protocol FoldersProtocolDelegate: AnyObject {
    func render(errorMessage: String)
    func renderLoading(visible: Bool)
    func render(viewModel: FoldersViewModel)
}
