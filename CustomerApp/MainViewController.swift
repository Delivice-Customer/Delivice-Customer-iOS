//
//  MainViewController.swift
//  CustomerApp
//
//  Created by Tong on 2/9/15.
//  Copyright (c) 2015 Delivice. All rights reserved.
//
//  Sliding panel code from:
//  http://www.raywenderlich.com/78568/create-slide-out-navigation-panel-swift
//

import UIKit

enum SlideOutState {
    case Collapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}

class MainViewController: UIViewController, CenterViewControllerDelegate, RightViewControllerDelegate, UIGestureRecognizerDelegate {
    
    // Properties
    
    var centerNavigationController: UINavigationController!
    var centerViewController: CenterViewController!
    
    var currentState: SlideOutState = .Collapsed
    var leftViewController: LeftViewController?
    var rightViewController: RightViewController?

    let centerPanelExpandedOffsetLeft: CGFloat = 100
    let centerPanelExpandedOffsetRight: CGFloat = 0

    
    // Generated methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self

        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMoveToParentViewController(self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: CenterViewController delegate methods
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func toggleRightPanel() {
        let notAlreadyExpanded = (currentState != .RightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            addLeftChildSidePanelController(leftViewController!)
        }
    }
    
    func addRightPanelViewController() {
        if (rightViewController == nil) {
            rightViewController = UIStoryboard.rightViewController()
            rightViewController?.delegate = self
            let rightGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handleRightGesture:")
            rightViewController!.view.addGestureRecognizer(rightGestureRecognizer)
            
            addRightChildSidePanelController(rightViewController!)
        }
    }
    
    func addLeftChildSidePanelController(sidePanelController: LeftViewController) {
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func addRightChildSidePanelController(sidePanelController: RightViewController) {
        view.insertSubview(sidePanelController.view, atIndex: 0)
        sidePanelController.view.frame.origin.x = CGRectGetWidth(centerNavigationController.view.frame)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func animateLeftPanel(#shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffsetLeft)
        }
        else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .Collapsed
                
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    
    func animateRightPanel(#shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .RightPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: -CGRectGetWidth(centerNavigationController.view.frame) + centerPanelExpandedOffsetRight)
            animateRightPanelXPosition(targetPosition: 0)
        }
        else {
            animateRightPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame))

            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .Collapsed
                
                self.rightViewController!.view.removeFromSuperview()
                self.rightViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func animateRightPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.rightViewController!.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    // MARK: Gesture Recognizer
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        
        switch(recognizer.state) {
        case .Began:
            if (currentState == .Collapsed) {
                if (gestureIsDraggingFromLeftToRight) {
                    addLeftPanelViewController()
                }
                else {
                    addRightPanelViewController()
                }
            }
        case .Changed:
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
            if (rightViewController != nil) {
                rightViewController!.view.center.x = rightViewController!.view.center.x + recognizer.translationInView(view).x
            }
            recognizer.setTranslation(CGPointZero, inView: view)
        case .Ended:
            if (leftViewController != nil) {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                var hasMovedGreaterThanHalfway : Bool
                if (gestureIsDraggingFromLeftToRight) {
                    hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width - centerPanelExpandedOffsetLeft
                }
                else {
                    hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width + centerPanelExpandedOffsetLeft
                }
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
            else if (rightViewController != nil) {
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x < 0
                animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }
    
    func handleRightGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        
        switch(recognizer.state) {
        case .Changed:
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
            centerNavigationController.view.center.x = centerNavigationController.view.center.x + recognizer.translationInView(view).x
            recognizer.setTranslation(CGPointZero, inView: view)
        case .Ended:
            if (rightViewController != nil) {
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x < 0
                animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }

}


private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func leftViewController() -> LeftViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? LeftViewController
    }
    
    class func centerViewController() -> CenterViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? CenterViewController
    }
    
    class func rightViewController() -> RightViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("RightViewController") as? RightViewController
    }
}