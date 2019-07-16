//
//  HalfModalTransitioningDelegate.swift
//  ModalWebView
//
//  Created by Kalyan Vishnubhatla on 7/13/19.
//  Copyright © 2019 Kalyan Vishnubhatla. All rights reserved.
//

import UIKit

public class ModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var interactionController: ModalInteractiveTransition
    
    public init(viewController: UIViewController, presentingViewController: UIViewController) {
        self.interactionController = ModalInteractiveTransition(viewController: viewController, withView: presentingViewController.view, presentingViewController: presentingViewController)
        super.init()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalTransitionAnimator()
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }
}
