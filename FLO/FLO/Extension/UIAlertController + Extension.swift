//
//  UIAlertController + Extension.swift
//  FLO
//
//  Created by 심영민 on 6/24/24.
//

import UIKit

extension UIAlertController
{
    static func makeOneButtonAlertViewController(title: String? = nil,
                                                 message: String? = nil,
                                                 confirmAction: ((UIAlertAction) -> Void)? = nil,
                                                 completion: (() -> Void)? = nil) -> UIAlertController
    {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: confirmAction)
        
        alertViewController.addAction(confirmAction)
        return alertViewController
    }
}
