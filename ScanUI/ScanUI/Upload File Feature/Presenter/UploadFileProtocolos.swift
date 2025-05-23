//
//  UploadFileProtocolos.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation

@MainActor
public protocol UploadFileProtocols: ScanProtocol {
    var currentProductFeature: ProductFeature { get set }

    func startScan(atURL url: URL) async
    func adIsEnabled() -> Bool
    func showAdvFromViewModelIfNeeded()
    
    @Sendable func loadFilesType() async
    @Sendable func loadAd() async
    
    func handleTryAgain()
    func handleCancelAction()
}

@MainActor
public protocol UploadFileProtocolsDelegate: AnyObject {
    func render(errorMessage: String)
    func render(viewModel: UploadFileViewModel)
    func renderInitState()
    func resetErrorState()
}
