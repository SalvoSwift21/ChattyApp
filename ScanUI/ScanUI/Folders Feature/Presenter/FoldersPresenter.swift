//
//  UploadFilePresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation
import OCRFeature

public class FoldersPresenter: FoldersPresenterProtocol {
    
    internal var didSelectFolder: ((Folder) -> Void)?
    internal var resourceBundle: Bundle
    internal var currentProductFeature: ProductFeature
    internal var bannerID: String
    
    private var service: FoldersServiceProtocol
    private weak var delegate: FoldersProtocolDelegate?
    

    public init(delegate: FoldersProtocolDelegate,
                service: FoldersServiceProtocol,
                currentProductFeature: ProductFeature,
                bannerID: String,
                didSelectFolder: ((Folder) -> Void)?,
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.resourceBundle = bundle
        self.didSelectFolder = didSelectFolder
        self.currentProductFeature = currentProductFeature
        self.bannerID = bannerID
    }
    
    @MainActor
    func loadData() async {
        let folders = await service.getFolders()
        let vModel = FoldersViewModel(folders: folders)
        self.delegate?.render(viewModel: vModel)
    }
    
    func createNewFolder(name: String) async {
        do {
            try await self.service.createFolder(name: name)
            await self.loadData()
        } catch {
            await self.delegate?.render(errorMessage: error.localizedDescription)
        }
    }
    
    func getStorage() -> ScanStorege {
        service.getStorage()
    }
    
    func renameFolder(folder: Folder) async {
        do {
            try await self.service.renameFolder(folder: folder)
            await self.loadData()
        } catch {
            await self.delegate?.render(errorMessage: error.localizedDescription)
        }
    }
    
    func deleteFolder(folder: Folder) async {
        do {
            try await self.service.deleteFolder(folder: folder)
            await self.loadData()
        } catch {
            await self.delegate?.render(errorMessage: error.localizedDescription)
        }
    }
    
    func handleErrorButton() {
        Task {
            await self.delegate?.render(errorMessage: nil)
        }
    }
}

//MARK: Help for Home
extension FoldersPresenter {
    @MainActor
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
}
