//
//  BookmarkReader.ScrollHandler.swift
//  Rede / App
//
//  Created by Marcus Rossel on 01.12.20.
//

import SwiftUI
import WebKit

extension BookmarkReader {
    
    final class ScrollHandler: NSObject, UIScrollViewDelegate, ObservableObject {
        
        enum Direction { case up, down }
        
        var onFastScroll: ((Direction) -> Void)? = nil
        
        weak var webView: WKWebView? {
            didSet {
                webView?
                    .scrollView
                    .panGestureRecognizer
                    .addTarget(self, action: #selector(didScroll(sender:)))
            }
        }
        
        @objc private func didScroll(sender: UIPanGestureRecognizer) {
            switch sender.velocity(in: webView).y {
            case ...(-700): onFastScroll?(.down)
            case 2000...:   onFastScroll?(.up)
            default:        break
            }
        }
    }
}
