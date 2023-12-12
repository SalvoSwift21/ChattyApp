//
//  HomePresenter.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 12/12/23.
//

import Foundation


public class HomePresenter: HomePresenterProtocol {
    
    public var resourceBundle: Bundle
    
    private var service: HomeService
    private weak var delegate: HomePresenterDelegate?
    
    private var homeViewModel: HomeViewModel

    public init(service: HomeService, delegate: HomePresenterDelegate, bundle: Bundle = Bundle(identifier: "com.ariel.ScanUI") ?? .main) {
        self.service = service
        self.delegate = delegate
        self.resourceBundle = bundle
        self.homeViewModel = HomeViewModel()
    }
    
    public func getSearchResult(for query: String) async {
        do {
            self.showLoader(true)
            let result = try await service.searchFiles(from: query)
            self.homeViewModel.searchResults = result
            self.delegate?.render(viewModel: homeViewModel)
            self.showLoader(false)
        } catch {
            self.delegate?.renderSearch(errorMessage: error.localizedDescription)
            self.showLoader(false)
        }
    }
    
    @Sendable public func getHome() async {
        do {
            self.showLoader(true)
            let myFolders = try await service.getMyFolder()
            let myRecentScan = try await service.getRecentScans()
            
            self.homeViewModel.myFolders = myFolders
            self.homeViewModel.recentScans = myRecentScan
            
            self.delegate?.render(viewModel: homeViewModel)
            self.showLoader(false)
        } catch {
            self.delegate?.renderSearch(errorMessage: error.localizedDescription)
            self.showLoader(false)
        }
    }
    
    public func uploadImage() {
        print("upload img tap")
    }
    
    public func newScan() {
        print("start new scan")
    }
}

//MARK: Help for Home
extension HomePresenter {
    
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
}
