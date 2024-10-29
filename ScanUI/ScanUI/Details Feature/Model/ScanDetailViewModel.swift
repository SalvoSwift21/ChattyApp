//
//  UploadFileViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/01/24.
//

import Foundation
import SwiftUI

public struct ScanDetailViewModel {
    
    var scan: Scan
    
    public init(scan: Scan) {
        self.scan = scan
    }
    
    
    func getSharableObject() -> ScanShareModel {
        let image = Image(uiImage: scan.mainImage ?? UIImage())
        return ScanShareModel(image: image, description: scan.contentText)
    }
}

struct ScanShareModel: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }


    public var image: Image
    public var description: String
}

