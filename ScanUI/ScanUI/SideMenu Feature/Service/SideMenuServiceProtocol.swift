//
//  SideMenuServiceProtocol.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation

public protocol SideMenuServiceProtocol: AnyObject {
    func getMenuSections() async throws -> [MenuSection]
}

