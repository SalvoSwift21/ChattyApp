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
        
    public static func uploadFileModifierView(
        isPresented: Binding<Bool>,
        scanResult: @escaping (ScanResult) -> Void = { _ in }
    ) -> UploadFileView {
        
        let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
        let uploadFileStore = UploadFileStore(state: .error(message: "View not load"))
                
        let uploadFilePresenter = UploadFilePresenter(delegate: uploadFileStore, resultOfScan: scanResult, bundle: bundle)

        return UploadFileView(isPresented: isPresented, store: uploadFileStore, presenter: uploadFilePresenter)
    }
}

extension View {
    func fileImporter(isPresented: Binding<Bool>, scanResult: @escaping (ScanResult) -> Void = { _ in }) -> some View {
        modifier(UploadFileComposer.uploadFileModifierView(isPresented: isPresented, scanResult: scanResult))
    }
}
