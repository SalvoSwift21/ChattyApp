//
//  ImageScannerComposer.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 08/01/24.
//

import Foundation
import ScanUI
import SwiftUI

public final class UploadFileComposer {
    private init() {}
    
    static var uploadFileStore: UploadFileStore?

    @MainActor
    public static func uploadFileModifierView(
        isPresented: Binding<Bool>,
        scanResult: @escaping (ScanResult) -> Void = { _ in }
    ) -> UploadFileView {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        
        let uploadFileStore = UploadFileStore(state: .initState)
        
        if UploadFileComposer.uploadFileStore == nil {
            UploadFileComposer.uploadFileStore = uploadFileStore
        }
        let currentProduct = AppConfiguration.shared.purchaseManager.currentAppProductFeature
        let service = UploadFileService(UTTypes: AppConfiguration.shared.currentPreference.selectedAI.aiType.getAISupportedFileTypes(forProductFeature: currentProduct))
        
        let uploadFilePresenter = UploadFilePresenter(delegate: UploadFileComposer.uploadFileStore ?? uploadFileStore, service: service, bundle: bundle, currentProductFeature: currentProduct, interstitialID: AppConfiguration.shared.adMobManager.getInterstitialUnitId(), resultOfScan: scanResult)

        return UploadFileView(isPresented: isPresented, store: UploadFileComposer.uploadFileStore ?? uploadFileStore, presenter: uploadFilePresenter, resourceBundle: bundle)
    }
}

extension View {
    func fileImporter(isPresented: Binding<Bool>, scanResult: @escaping (ScanResult) -> Void = { _ in }) -> some View {
        modifier(UploadFileComposer.uploadFileModifierView(isPresented: isPresented, scanResult: scanResult))
    }
}
