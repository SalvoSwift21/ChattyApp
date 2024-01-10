//
//  ScanViewModel.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import Foundation
import VisionKit

public class ScanViewModel {
    var dataScannerController: DataScannerViewController
    public init(dataScannerController: DataScannerViewController) {
        self.dataScannerController = dataScannerController
    }
}
