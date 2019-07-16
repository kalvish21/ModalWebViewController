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

open class WebViewController: UIViewController {
    var url: URL!
    var webView: WKWebView!
    
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
        
        setup()
        webView.load(URLRequest(url: url))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(cancelClicked))
    }
    
    private func setup() {
        webView = WKWebView(frame: self.view.bounds)
        webView.scrollView.bounces = false
        view.addSubview(webView)
    }
    
    @objc func cancelClicked() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
