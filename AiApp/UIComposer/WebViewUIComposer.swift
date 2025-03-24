//
//  WebViewUIComposer.swift
//  AiApp
//
//  Created by Salvatore Milazzo on 3/20/25.
//

import Foundation
import ScanUI
import SwiftUI

public final class WebViewUIComposer {
    private init() {}
        
     
    public static func webViewComposedWith(
        url: URL
    ) -> WebViewSwiftUI {
        return WebViewSwiftUI(url: url)
    }
}
