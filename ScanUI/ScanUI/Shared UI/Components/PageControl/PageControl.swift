//
//  PageControl.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 01/12/23.
//

import SwiftUI
import UIKit

public struct PageControl: UIViewRepresentable {
    public var numberOfPages: Int
    @Binding public var currentPage: Int

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateCurrentPage(sender:)),
            for: .valueChanged)
        control.pageIndicatorTintColor = .footer
        control.currentPageIndicatorTintColor = .prime
        return control
    }

    public func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }

    public class Coordinator: NSObject {
        var control: PageControl

        init(_ control: PageControl) {
            self.control = control
        }

        @objc
        func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}

