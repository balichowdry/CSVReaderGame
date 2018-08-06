//
//  UIViewController+Toast.swift
//  Vocabulory Trainer
//
//  Created by BilalSattar on 05/08/2018.
//  Copyright © 2018 BilalSattar. All rights reserved.
//

import Foundation
import UIKit
//MARK: Custom Toast message
extension UIViewController {
    
    //Add a toast message on Screen
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-300, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.numberOfLines = 0
        toastLabel.font = UIFont(name: "Montserrat-Bold", size: 18.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.adjustsFontSizeToFitWidth = true
        if message == "CORRECT"
        {
            toastLabel.backgroundColor = .green
        }
        else {
            toastLabel.backgroundColor = .red

        }
    
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.3, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
