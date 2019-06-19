//
//  AsIsWebViewController.swift
//  ClockInOut
//
//  Created by 鈴木航 on 2019/09/03.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit
import WebKit

class AsIsWebViewController: UIViewController,
    WKNavigationDelegate
{

    let webView = WKWebView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.autoPinEdgesToSuperviewEdges()
        webView.load(URLRequest(url: URL(string: "")!))
    }

    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            print("request url = \(url.absoluteString)")
        }
        print(navigationAction.request)
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let url = navigationResponse.response.url {
            print("response url = \(url.absoluteString)")
        }
        print(navigationResponse.response)
        decisionHandler(.allow)
    }
}

