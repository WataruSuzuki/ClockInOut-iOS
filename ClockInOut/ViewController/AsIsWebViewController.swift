//
//  AsIsWebViewController.swift
//  ClockInOut
//
//  Created by 鈴木航 on 2019/09/03.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit
import WebKit

class AsIsWebViewController: UIViewController {

    let webView = WKWebView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(webView)
        webView.autoPinEdgesToSuperviewEdges()
        webView.load(URLRequest(url: URL(string: "")!))
    }

}

