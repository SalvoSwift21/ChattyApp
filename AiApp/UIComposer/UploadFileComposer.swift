//
//  ImageScannerComposer.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 08/01/24.
//

import Foundation
import ScanUI

public final class UploadFileComposer {
    private init() {}
        
    public static func uploadFileComposedWith(
        scanResult: @escaping (String) -> Void = { _ in }
    ) -> UploadFileView {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let uploadFileStore = UploadFileStore()
                
        let uploadFilePresenter = UploadFilePresenter(delegate: uploadFileStore, resultOfScan: scanResult, bundle: bundle)
        
        return UploadFileView(store: uploadFileStore, presenter: uploadFilePresenter)
    }
}
