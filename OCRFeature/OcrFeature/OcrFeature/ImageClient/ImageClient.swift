//
//  ImageClient.swift
//  OCRFeature
//
//  Created by Salvatore Milazzo on 18/12/23.
//

import Foundation

public protocol ImageClient {
    func getVideoStream() async throws -> Stream
}
