//
//  Alert.swift
//  SwiftCurrency
//
//  Created by Tushar on 15/08/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
