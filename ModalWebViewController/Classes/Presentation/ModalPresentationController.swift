//
//  HalfModalPresentationController.swift
//  HalfModalPresentationController
//
//  Created by Kalyan Vishnubhatla on 7/13/19.
//  Copyright © 2019 Kalyan Vishnubhatla. All rights reserved.
//

import UIKit

class ModalPresentationController : UIPresentationController {
    var panGestureRecognizer: UIPanGestureRecognizer
    var webViewPan: UIPanGestureRecognizer
    
    var direction: CGFloat = 0
    let limit: CGFloat = 200
    var originalPresentedViewFrame: CGRect? = nil
    
    var _dimmingView: UIView?
    var dimmingView: UIView {
        if let dimmedView = _dimmingView {
            return dimmedView
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: containerView!.bounds.width, height: containerView!.bounds.height))
        
        // Blur Effect
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // Vibrancy Effect
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = view.bounds
        
        // Add the vibrancy view to the blur view
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        
        _dimmingView = view
        
        return view
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        panGestureRecognizer = UIPanGestureRecognizer()
        webViewPan = UIPanGestureRecognizer()
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        panGestureRecognizer.addTarget(self, action: #selector(onPan(pan:)))
        presentedViewController.view.addGestureRecognizer(panGestureRecognizer)
        
        webViewPan.addTarget(self, action: #selector(onWebViewPan(pan:)))
        webViewPan.delegate = self
        
        setCornerRadius(true)
    }
    
    @objc func onPan(pan: UIPanGestureRecognizer) -> Void {
        let location = pan.location(in: pan.view?.superview)
        let velocity = pan.velocity(in: pan.view?.superview)
        
        switch pan.state {
        case .changed:
            let yValue = location.y
            let width = presentedView?.frame.size.width ?? 0
            let height = UIScreen.main.bounds.height - yValue
            presentedView?.frame = CGRect(x: 0, y: yValue, width: width, height: height)
            
            setCornerRadius(true)
            direction = velocity.y
            
        case .ended:
            if direction < 0 {
                changeScale()
            } else {
                presentedViewController.dismiss(animated: true, completion: nil)
            }
            
        default:
            break
        }
    }
    
    @objc func onWebViewPan(pan: UIPanGestureRecognizer) {
        let yTranslation = pan.translation(in: presentedView).y
        let draggingUp = pan.velocity(in: presentedView).y < 0
        let frame = presentedView?.frame ?? CGRect.zero
        
        if !draggingUp {
            let containerFrame = containerView!.frame
            let newY = containerFrame.origin.y + yTranslation
            let height = containerFrame.height * 0.9 - newY
            presentedView?.frame = CGRect(x: 0, y: containerFrame.height - height, width: frame.size.width, height: height)
            if(pan.state == .ended){
                if newY <= limit {
                    animateViewBackToTopLimit()
                } else {
                    presentedViewController.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func animateViewBackToTopLimit() {
        if let presentedView = self.presentedView, let originalPresentedViewFrame = self.originalPresentedViewFrame {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
                presentedView.frame = originalPresentedViewFrame
            }, completion: nil)
        }
    }
    
    func setCornerRadius(_ shouldSet: Bool = false) {
        presentedView?.clipsToBounds = true
        if shouldSet {
            if let presentedView = presentedView {
                presentedView.layer.cornerRadius = 15.0
            }
        } else {
            if let presentedView = presentedView {
                presentedView.layer.cornerRadius = 0.0
            }
        }
    }
    
    func changeScale() {
        if let presentedView = presentedView, let containerView = self.containerView {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { () -> Void in
                presentedView.frame = containerView.frame
                let containerFrame = containerView.frame
                let yValue = containerFrame.height - containerFrame.height * 0.9
                let rect = CGRect(origin: CGPoint(x: 0, y: yValue), size: CGSize(width: containerFrame.width, height: containerFrame.height * 0.9))
                presentedView.frame = rect
                
                if let navController = self.presentedViewController as? UINavigationController {
                    navController.setNeedsStatusBarAppearanceUpdate()
                    
                    // Force the navigation bar to update its size
                    navController.isNavigationBarHidden = true
                    navController.isNavigationBarHidden = false
                }
            }, completion: nil)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let containerFrame = containerView!.frame
        let yValue = containerFrame.height - containerFrame.height * 0.9
        let rect = CGRect(origin: CGPoint(x: 0, y: yValue), size: CGSize(width: containerFrame.width, height: containerFrame.height * 0.9))
        return rect
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        if let nav = presentedViewController as? UINavigationController, let vc = nav.topViewController as? WebViewController {
            vc.webView.scrollView.addGestureRecognizer(webViewPan)
            
            if originalPresentedViewFrame == nil {
                originalPresentedViewFrame = presentedView?.frame ?? CGRect.zero
            }
        }
    }
    
    override func presentationTransitionWillBegin() {
        let dimmedView = dimmingView
        
        if let containerView = self.containerView, let coordinator = presentingViewController.transitionCoordinator {
            
            dimmedView.alpha = 0
            containerView.addSubview(dimmedView)
            dimmedView.addSubview(presentedViewController.view)
            
            coordinator.animate(alongsideTransition: { (context) -> Void in
                dimmedView.alpha = 1
                self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentingViewController.transitionCoordinator {
            
            coordinator.animate(alongsideTransition: { (context) -> Void in
                self.dimmingView.alpha = 0
                self.presentingViewController.view.transform = CGAffineTransform.identity
            }, completion: nil)
            
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
            _dimmingView = nil
        }
    }
}

extension ModalPresentationController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer != webViewPan
    }
}

protocol HalfModalPresentable { }

extension HalfModalPresentable where Self: UIViewController {
    func maximizeToFullScreen() -> Void {
        if let presetation = navigationController?.presentationController as? ModalPresentationController {
            presetation.changeScale()
        }
    }
}
