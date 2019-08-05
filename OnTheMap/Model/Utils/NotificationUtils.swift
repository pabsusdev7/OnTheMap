//
//  NotificationUtils.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 8/2/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import Foundation
import UIKit

class NotificationUtils {
    
    class func showMessage(message: String, title: String, action: String, vc: UIViewController, dismissParent: Bool){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: action, style: .default, handler: !dismissParent ? nil : { action
                in
                vc.dismiss(animated: true, completion: nil)
            
            }))
        vc.present(alertVC, animated: true, completion: nil)
    }
    
    class func showErrorMessage(message: String, action: String, vc: UIViewController, dismissParent: Bool = false){
        showMessage(message: message, title: "Error", action: action, vc: vc, dismissParent: dismissParent)
    }
    
    class func showSuccessMessage(message: String, action: String, vc: UIViewController, dismissParent: Bool = false){
        showMessage(message: message, title: "Success", action: action, vc: vc, dismissParent: dismissParent)
    }
    
    
}
