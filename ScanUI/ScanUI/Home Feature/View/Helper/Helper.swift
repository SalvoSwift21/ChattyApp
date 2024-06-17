//
//  Helper.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/12/23.
//

import UIKit

func createSomeFolders() -> [Folder] {
    let scans = createScans()
    let folder = Folder(title: "Personal", scans: scans)
    let folder1 = Folder(title: "Official", scans: scans)
    let folder2 = Folder(title: "Other", scans: scans)
    let folder3 = Folder(title: "Altre cose con nome lungo", scans: scans)
    return [folder, folder1, folder2, folder3]
}

func createScans() -> [Scan] {
    return [Scan(title: "Prima Scansione", scanDate: .now, mainImage: UIImage(named: "default_scan", in: Bundle(identifier: "com.ariel.ScanUI"), with: nil)),
            Scan(title: "Seconda Scansione Scansione Scansione Scansione Scansione Scansione", scanDate: .now, mainImage: UIImage(named: "default_scan", in: Bundle(identifier: "com.ariel.ScanUI"), with: nil)),
            Scan(title: "Terza scansione", scanDate: .now, mainImage: UIImage(named: "default_scan", in: Bundle(identifier: "com.ariel.ScanUI"), with: nil))]
}
