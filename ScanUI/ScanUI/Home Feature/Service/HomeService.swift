//
//  HomeService.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 11/12/23.
//

import Foundation
import RestApi

public class HomeService: HomeServiceProtocol {
    
    public enum HomeServiceError: Swift.Error {
        case URLDataNotValid
    }
    
    private var client: URLSessionHTTPClient
    
    public init(client: URLSessionHTTPClient) {
        self.client = client
    }
    
    public func getMyFolder() async throws -> [Folder] {
        return createSomeFolders()
    }
    
    public func getRecentScans() async throws -> [Scan] {
        return createScans()
    }
}