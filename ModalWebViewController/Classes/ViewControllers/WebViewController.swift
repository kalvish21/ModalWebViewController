//
//  WebViewController.swift
//  ModalWebView
//
//  Created by Kalyan Vishnubhatla on 7/13/19.
//  Copyright © 2019 Kalyan Vishnubhatla. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import PopMenu

open class WebViewController: UIViewController {
    var url: URL!
    var webView: WKWebView!
    
    var backBarButtonItem: UIBarButtonItem!
    var forwardBarButtonItem: UIBarButtonItem!
    
    public static func openModalWebView(with url: URL, viewController: UIViewController) {
        let navigationCont = UINavigationController(rootViewController: WebViewController(url: url))
        let halfModalTransitioningDelegate = ModalTransitioningDelegate(viewController: viewController, presentingViewController: navigationCont)
        navigationCont.modalPresentationStyle = .custom
        navigationCont.transitioningDelegate = halfModalTransitioningDelegate
        viewController.present(navigationCont, animated: true, completion: nil)
    }
    
    public init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        title = url.absoluteString
        setup()
        webView.load(URLRequest(url: url))
        
        let backImage = UIImage(named: "back.png", in: Bundle(for: WebViewController.self), compatibleWith: nil)
        let forwardImage = UIImage(named: "forward.png", in: Bundle(for: WebViewController.self), compatibleWith: nil)
        backBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backClicked))
        forwardBarButtonItem = UIBarButtonItem(image: forwardImage, style: .plain, target: self, action: #selector(backClicked))
        navigationItem.leftBarButtonItems = [backBarButtonItem, forwardBarButtonItem]
        
        let menuImage = UIImage(named: "menu.png", in: Bundle(for: WebViewController.self), compatibleWith: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(menuClicked))
    }
    
    private func setup() {
        webView = WKWebView(frame: self.view.bounds)
        webView.scrollView.bounces = false
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
    
    @objc func backClicked() {
        webView.goBack()
    }
    
    @objc func forwardClicked() {
        webView.goForward()
    }
    
    @objc func menuClicked() {
        let menu = PopMenuViewController(actions: [
            PopMenuDefaultAction(title: "Refresh", didSelect: { action in
                self.webView.reload()
            }),
            PopMenuDefaultAction(title: "Copy", didSelect: { action in
                UIPasteboard.general.string = self.url.absoluteString
            }),
            PopMenuDefaultAction(title: "Open in Safari", didSelect: { action in
                UIApplication.shared.open(self.url, options: [:], completionHandler: nil)
            })
        ])
        present(menu, animated: true, completion: nil)
    }
}

extension WebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backBarButtonItem.isEnabled = webView.canGoBack
        forwardBarButtonItem.isEnabled = webView.canGoForward
    }
}
