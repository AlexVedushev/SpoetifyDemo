//
//  UIViewController+ChildViewController.swift
//  Pods
//
//  Created by Maxim Soloviev on 08/06/16.
//  Copyright © 2016 Maxim Soloviev. All rights reserved.
//

import UIKit
import PureLayout

extension UIViewController {
    
    public func or_addChildViewController(_ childVC: UIViewController, intoView containerView: UIView, addConstraints: Bool = true) {
        addChildViewController(childVC)
        
        childVC.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        containerView.addSubview(childVC.view)
        if addConstraints {
            childVC.view.autoPinEdgesToSuperviewEdges()
        }
        childVC.didMove(toParentViewController: self)
    }
    
    public func or_removeFromParentViewController() {
        willMove(toParentViewController: nil)
        
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}
