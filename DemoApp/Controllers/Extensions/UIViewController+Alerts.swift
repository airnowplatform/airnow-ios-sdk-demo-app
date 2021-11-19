//
//  UIViewController+Alerts.swift
//  DevApp
//
//  Created by Gusakovsky, Sergey on 4/7/21.
//  Copyright © 2021 QulixSystems. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    public func presentMessageDialog(title: String, message: String? = nil, actionTitle: String, completed: (() -> Void)? = nil) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.presentMessageDialog(title: title, message: message, actionTitle: actionTitle, completed: completed)
            }
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: completed)
    }
    
    public func presentMessageDialog(title: String, message: String? = nil, actionTitle: String? = nil, action: (() -> Void)?, cancelTitle: String? = nil, cancelAction: (() -> Void)?) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.presentMessageDialog(title: title, message: message, actionTitle: actionTitle, action: action, cancelAction: cancelAction)
            }
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelTitle ?? "Cancel", style: UIAlertAction.Style.cancel) { UIAlertAction in
            if let cancelAction = cancelAction {
                cancelAction()
            }
            
        }
        let okAction = UIAlertAction(title: actionTitle ?? "OK", style: UIAlertAction.Style.default) { UIAlertAction in
            if let action = action {
                action()
            }
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
}
