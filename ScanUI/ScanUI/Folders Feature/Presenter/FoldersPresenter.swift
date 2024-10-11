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

    private var service: FoldersServiceProtocol
    private weak var delegate: FoldersProtocolDelegate?
    

    public init(delegate: FoldersProtocolDelegate,
                service: FoldersServiceProtocol,
                didSelectFolder: ((Folder) -> Void)?,
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.resourceBundle = bundle
        self.didSelectFolder = didSelectFolder
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
            print("Error new folder not created, error \(error)")
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
            print("Error new folder not created, error \(error)")
        }
    }
    
    func deleteFolder(folder: Folder) async {
        do {
            try await self.service.deleteFolder(folder: folder)
            await self.loadData()
        } catch {
            print("Error new folder not created, error \(error)")
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
