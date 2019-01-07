//
//  RepositoryWebViewController.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

final class RepositoryWebViewController: UIViewController {

    // MARK: - Properties
    
    var repositoryURLStr: String!
    var repositoryName: String!
    
    private let wkWebView = WKWebView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        loadRepositoryWeb()
    }
}

// MARK: - Class Extension
extension RepositoryWebViewController {
    
    private func setupWebView() {
        
        title = repositoryName
        
        wkWebView.frame = view.frame
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        
        // スワイプでの「戻る・すすむ」を有効にする
        wkWebView.allowsBackForwardNavigationGestures = true
    }
    
    private func loadRepositoryWeb() {
        
        guard let repositoryURL = URL(string: repositoryURLStr ?? "")
            else { return }
        SVProgressHUD.show()
        let urlRequest = URLRequest(url: repositoryURL)
        wkWebView.load(urlRequest)
        view.addSubview(wkWebView)
    }
}

// MARK: - WKNavigationDelegate
extension RepositoryWebViewController: WKNavigationDelegate {
    
    // ウェブのロード完了時に呼び出される
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        SVProgressHUD.dismiss()
    }
}

// MARK: - WKUIDelegate
extension RepositoryWebViewController: WKUIDelegate {
    
    // blank対策
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        
        return nil
    }
}
