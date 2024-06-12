//
//  UploadFilePresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation
import OCRFeature

public class FoldersPresenter: FoldersPresenterProtocol {
    
    internal var didSelectFolder: ((Folder) -> Void)
    internal var resourceBundle: Bundle

    private var service: FoldersServiceProtocol
    private weak var delegate: FoldersProtocolDelegate?
    

    public init(delegate: FoldersProtocolDelegate,
                service: FoldersServiceProtocol,
                didSelectFolder: @escaping ((Folder) -> Void),
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.resourceBundle = bundle
        self.didSelectFolder = didSelectFolder
    }
    
    func loadData() async {
        let folders = await service.getFolders()
        let vModel = FoldersViewModel(folders: folders)
        self.delegate?.render(viewModel: vModel)
    }
    
    func createNewFolder(name: String) async { }
}

//MARK: Help for Home
extension FoldersPresenter {
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
}
