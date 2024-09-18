//
//  UploadFilePresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation
import UIKit

public class FolderDetailPresenter: FolderDetailPresenterProtocol {
    
    internal var resourceBundle: Bundle


    private var service: FolderDetailService
    private weak var delegate: FolderDetailProtocolDelegate?
    
    private var currentFolder: Folder?
    

    public init(delegate: FolderDetailProtocolDelegate,
                service: FolderDetailService,
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.resourceBundle = bundle
    }
    
    func loadData() async {
        let currentFolder = await service.getFolder()
        self.currentFolder = currentFolder
        self.delegate?.render(viewModel: FolderDetailViewModel(folder: currentFolder))
    }
    
}

//MARK: Help for Home
extension FolderDetailPresenter {
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
}
