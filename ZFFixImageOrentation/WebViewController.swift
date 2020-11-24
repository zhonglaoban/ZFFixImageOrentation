//
//  WebViewController.swift
//  ZFFixImageOrentation
//
//  Created by 钟凡 on 2020/11/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    lazy var webView:WKWebView = {
        let webconfig = WKWebViewConfiguration()
        let w = WKWebView(frame: .zero, configuration: webconfig)
        
        return w
    }()
    var fileUrl: URL?
    var pathUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        webView.loadFileURL(fileUrl!, allowingReadAccessTo: pathUrl!)
        view.addSubview(webView)
        webView.frame = view.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let button = UIButton()
        button.setTitle("close", for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 44)
    }
    
    @objc func close() {
        navigationController?.popViewController(animated: true)
    }
}
