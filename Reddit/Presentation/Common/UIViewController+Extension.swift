//
//  UIViewController+Extension.swift
//  MGT
//
//  Created by Agustinch on 10/09/2022.
//

import UIKit
import SafariServices

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
    
    func openConfigurations() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    func getGraddiantColor() -> UIColor? {
        let gradientStartColor = UIColor(red: 1.0, green: 0.537, blue: 0.376, alpha: 1.0)
        let gradientEndColor = UIColor(red: 1.0, green: 0.384, blue: 0.647, alpha: 1.0)
        let startPoint = CGPoint(x: 0.0, y: 0.0)
        let endPoint = CGPoint(x: 1.0, y: 1.0)

        let gradientColor = UIColor.gradientColor(startColor: gradientStartColor, endColor: gradientEndColor, startPoint: startPoint, endPoint: endPoint)

        return gradientColor
    }
    
    func openSafariURL(webUrl: String) {
        if let url = URL(string: webUrl) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
}
