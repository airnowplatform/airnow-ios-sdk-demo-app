//
//  UIViewController+ActivityIndicator.swift
//  AirMonetizationSDK
//
//  Created by Gusakovsky, Sergey on 3/26/21.
//  Copyright © 2021 QulixSystems. All rights reserved.
//

import UIKit

extension UIViewController {
    func showActivityIndicator(in insideView: UIView? = nil) {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activityIndicator.center = (insideView != nil) ? insideView!.center : view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.startAnimating()
        
        activityIndicator.tag = 100
        
        if insideView != nil {
            insideView!.addSubview(activityIndicator)
        } else {
            view.addSubview(activityIndicator)
        }
    }

    func hideActivityIndicator() {
        let activityIndicator = view.viewWithTag(100) as? UIActivityIndicatorView
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
    }
}
