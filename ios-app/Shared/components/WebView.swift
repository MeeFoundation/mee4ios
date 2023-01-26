//
//  WebView.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 13.7.22..
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    typealias Context = UIViewRepresentableContext<Self>
    typealias UIViewType = WKWebView
    let webView: WKWebView
    
    init(url: URL) {
        webView = WKWebView(frame: .zero)
        webView.load(URLRequest(url: url))
    }
    
}
