//
//  ViewController.swift
//  ModalWebViewController
//
//  Created by Kalyan Vishnubhatla on 07/15/2019.
//  Copyright (c) 2019 Kalyan Vishnubhatla. All rights reserved.
//

import UIKit
import ModalWebViewController

class ViewController: UIViewController {
    @IBAction func goClicked(_ sender: Any) {
        if let url = URL(string: "https://www.google.com") {
            WebViewController.openModalWebView(with: url, viewController: self)
        }
    }
}

