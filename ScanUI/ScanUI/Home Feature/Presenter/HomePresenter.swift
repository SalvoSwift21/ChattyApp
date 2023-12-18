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
    
    public func getSearchResult(for query: String) async { }
    
    @Sendable public func getHome() async {
        do {
            self.showLoader(true)
            let myFolders = try await service.getMyFolder()
            let myRecentScan = try await service.getRecentScans()
            
            self.homeViewModel.myFolders = myFolders
            self.homeViewModel.recentScans = myRecentScan
            
            self.delegate?.render(viewModel: homeViewModel)
        } catch {
            self.delegate?.render(errorMessage: error.localizedDescription)
            self.showLoader(false)
        }
    }
}

//MARK: Help for Home
extension HomePresenter {
    
    fileprivate func showLoader(_ show: Bool) {
        self.delegate?.renderLoading(visible: show)
    }
}
