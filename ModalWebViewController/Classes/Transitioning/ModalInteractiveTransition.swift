//
//  HalfModalInteractiveTransition.swift
//  HalfModalPresentationController
//
//  Created by Kalyan Vishnubhatla on 7/13/19.
//  Copyright © 2019 Kalyan Vishnubhatla. All rights reserved.
//

import UIKit

class ModalInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var viewController: UIViewController
    var presentingViewController: UIViewController?
    var shouldComplete: Bool = false
    
    init(viewController: UIViewController, withView view:UIView, presentingViewController: UIViewController?) {
        self.viewController = viewController
        self.presentingViewController = presentingViewController

        super.init()
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        finish()
    }
    
    override var completionSpeed: CGFloat {
        get {
            return 1.0 - self.percentComplete
        }
        set {}
    }
}
