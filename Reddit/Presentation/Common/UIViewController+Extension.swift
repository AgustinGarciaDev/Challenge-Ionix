//
//  UIViewController+Extension.swift
//  MGT
//
//  Created by Agustinch on 10/09/2022.
//

import UIKit

extension UIViewController {
    func makeActivityIndicator(size: CGSize) -> UIActivityIndicatorView {
        let style: UIActivityIndicatorView.Style
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                style = .large
            } else {
                style = .medium
            }
        } else {
            style = .medium
        }

        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.frame = .init(origin: .zero, size: size)

        return activityIndicator
    }
}
