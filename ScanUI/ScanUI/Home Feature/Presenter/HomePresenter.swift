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
    
    
    private var service: HomeService
    private weak var delegate: HomePresenterDelegate?
    
    private var homeViewModel: HomeViewModel

    public init(service: HomeService, 
                delegate: HomePresenterDelegate,
                uploadImage: @escaping (() -> Void),
                newScan: @escaping (() -> Void),
                bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.resourceBundle = bundle
        self.uploadImage = uploadImage
        self.newScan = newScan
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
    
    internal func getSearchResult(for query: String) async { }
    
    internal func getHome() async throws -> HomeViewModel {
        let myFolders = try await service.getMyFolder()
        let myRecentScan = try await service.getRecentScans()
        
        return HomeViewModel(recentScans: myRecentScan, myFolders: myFolders)
    }
    
    internal func createNewFolder(name: String) async {
        do {
            try await self.service.createFolder(name: name)
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
}
