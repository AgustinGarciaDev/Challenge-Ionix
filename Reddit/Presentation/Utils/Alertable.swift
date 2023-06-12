//
//  Alertable.swift
//  Reddit
//
//  Created by Agustinch on 08/02/2023.
//

import UIKit

protocol Alertable {}
extension Alertable where Self: UIViewController {
    
    func showAlert(
        title: String = "",
        message: String,
        preferredStyle: UIAlertController.Style = .alert,
        completion: ((UIAlertAction) -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: completion))
        self.present(alertController, animated: true, completion: nil)
    }
}
