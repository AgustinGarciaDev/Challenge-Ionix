//
//  notificationPermissionManager.swift
//  Reddit
//
//  Created by Agustin on 08/06/2023.
//

import UIKit
import UserNotifications

final class NotificationPermissionManager {
    static let shared = NotificationPermissionManager()

    private let notificationCenter = UNUserNotificationCenter.current()

    func requestNotificationPermission(completion: @escaping (Bool, Bool?) -> Void) {
        self.notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    completion(true, nil)
                case .notDetermined:
                    self.requestAuthorization(completion: completion)
                case .denied:
                    completion(false, nil)
                @unknown default:
                    completion(false, nil)
                }
            }
        }
    }

    private func requestAuthorization(completion: @escaping (Bool, Bool?) -> Void) {
        self.notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error requesting notification permissions: \(error.localizedDescription)")
                    completion(false, nil)
                } else if granted {
                    completion(true, true)
                } else {
                    completion(false, nil)
                }
            }
        }
    }
}
