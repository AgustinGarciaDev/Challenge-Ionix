//
//  EnumPage.swift
//  Reddit
//
//  Created by Agustin on 08/06/2023.
//

import Foundation

enum Pages: CaseIterable {
    case pageZero
    case pageOne
    case pageTwo

    var type: TypePermission {
        switch self {
        case .pageZero:
            return .camera
        case .pageOne:
            return .notification
        case .pageTwo:
            return .location
        }
    }

    var title: String {
        switch self {
        case .pageZero:
            return "Camera Access"
        case .pageOne:
            return "Enable push notifications"
        case .pageTwo:
            return "Enable location services"
        }
    }

    var image: String {
        switch self {
        case .pageZero:
            return Image.imageCamera
        case .pageOne:
            return Image.imageNotification
        case .pageTwo:
            return Image.imageLocation
        }
    }

    var description: String {
        switch self {
        case .pageZero:
            return "Please allow access to your camera to take photos"
        case .pageOne:
            return "Enable push notifications to let send you personal news and updates."
        case .pageTwo:
            return "We wants to access your location only to provide a better experience by helping you find new friends nearby."
        }
    }

    var index: Int {
        switch self {
        case .pageZero:
            return 0
        case .pageOne:
            return 1
        case .pageTwo:
            return 2
        }
    }
}
