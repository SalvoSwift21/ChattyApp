//
//  SideMenuService.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation

public class LocalSideMenuService: SideMenuServiceProtocol {
    
    public enum LocalSideMenuServiceError: Swift.Error {
        case JSONNotFound
        case JSONNotValid
    }
    
    private var resourceBundle: Bundle
        
    public init(resourceBundle: Bundle) {
        self.resourceBundle = resourceBundle
    }
    
    public func getMenuSections() async throws -> [MenuSection] {
        
        guard let resourceUrl = self.resourceBundle.url(forResource: "SideMenuConfiguration", withExtension: ".json") else {
            throw LocalSideMenuServiceError.JSONNotFound
        }
        
        
        guard let data = try? Data(contentsOf: resourceUrl) else {
            throw LocalSideMenuServiceError.JSONNotValid
        }
        
        return try JSONDecoder().decode([MenuSection].self, from: data)
    }
}
