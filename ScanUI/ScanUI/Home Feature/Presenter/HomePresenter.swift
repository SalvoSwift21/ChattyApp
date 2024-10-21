//
//  HomePresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 12/12/23.
//

import Foundation


public class HomePresenter: HomePresenterProtocol {
    
    
    public var resourceBundle: Bundle
    public var uploadImage: (() -> Void)
    public var newScan: (() -> Void)
    public var sellAllButton: (() -> Void)
    public var scanTapped: ((Scan) -> Void)
    public var menuButton: (() -> Void)
    public var folderTapped: ((Folder) -> Void)

    
    private var service: HomeService
    private weak var delegate: HomePresenterDelegate?
    
    private var homeViewModel: HomeViewModel

    public init(service: HomeService, 
                delegate: HomePresenterDelegate,
                uploadImage: @escaping (() -> Void),
                newScan: @escaping (() -> Void),
                sellAllButton: @escaping (() -> Void),
                scanTapped: @escaping ((Scan) -> Void),
                folderTapped: @escaping ((Folder) -> Void),
                menuButton: @escaping (() -> Void),
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.resourceBundle = bundle
        self.uploadImage = uploadImage
        self.newScan = newScan
        self.sellAllButton = sellAllButton
        self.scanTapped = scanTapped
        self.folderTapped = folderTapped
        self.menuButton = menuButton
        self.homeViewModel = HomeViewModel()
    }
    
    @MainActor
    public func loadData() async {
        self.showLoader(true)
        
        do {
            let newViewModel = try await getHome()
            self.homeViewModel = newViewModel
            self.delegate?.render(viewModel: homeViewModel)
        } catch {
            self.delegate?.render(errorMessage: error.localizedDescription)
        }
    }
    
    @MainActor
    internal func getSearchResult(for query: String) async {
        if query.isEmpty {
            self.resetSearchMode()
            return
        }
        
        do {
            let result = try await service.getSearchResults(for: query)
            self.homeViewModel.searchResult = HomeSearchResultViewModel(scans: result.1, folders: result.0)
            self.delegate?.render(viewModel: homeViewModel)
        } catch {
            self.resetSearchMode()
        }
    }
    
    internal func getHome() async throws -> HomeViewModel {
        let myFolders = try await service.getMyFolder()
        let myRecentScan = try await service.getRecentScans()
        
        return HomeViewModel(recentScans: myRecentScan, myFolders: myFolders)
    }
    
    internal func createNewFolder(name: String) async {
        do {
            try await self.service.createFolder(name: name)
            await self.loadData()
        } catch {
            print("Error new folder not created, error \(error)")
        }
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
extension HomePresenter {
    
    public func createNewFolderAndReload(name: String) async {
        do {
            try await self.service.createFolder(name: name)
            await self.loadData()
        } catch {
            print("Error new folder not created, error \(error)")
        }
    }
    
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
    
    fileprivate func resetSearchMode() {
        self.homeViewModel.searchResult = nil
        self.delegate?.render(viewModel: homeViewModel)
    }
}
