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
    return [Scan(title: "Prima Scansione", contentText: "General fix", scanDate: .now, mainImageData: UIImage(named: "default_scan", in: Bundle(identifier: "com.ariel.ScanUI"), with: nil)?.pngData()),
            Scan(title: "Seconda Scansione Scansione Scansione Scansione Scansione Scansione", contentText: "È sopravvissuto non solo a più di cinque secoli, ma anche al passaggio alla videoimpaginazione, pervenendoci sostanzialmente inalterato. Fu reso popolare, negli anni ’60, con la diffusione dei fogli di caratteri trasferibili “Letraset”, che contenevano passaggi del Lorem Ipsum, e più recentemente da software di impaginazione come Aldus PageMaker, che includeva versioni del Lorem Ipsum.", scanDate: .now, mainImageData: UIImage(named: "default_scan", in: Bundle(identifier: "com.ariel.ScanUI"), with: nil)?.pngData()),
            Scan(title: "Terza scansione", contentText: "", scanDate: .now, mainImageData: UIImage(named: "default_scan", in: Bundle(identifier: "com.ariel.ScanUI"), with: nil)?.pngData())]
}
