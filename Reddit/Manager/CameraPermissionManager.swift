//
//  CamaraManager.swift
//  Reddit
//
//  Created by Agustin on 08/06/2023.
//

import AVFoundation

final class CameraPermissionManager {
    
    static let shared = CameraPermissionManager()
    
    func requestCameraPermission(completion: @escaping (Bool, AVAuthorizationStatus?) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true,nil)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted, .notDetermined)
                }
            }
        case .denied, .restricted:
            completion(false,nil)
        @unknown default:
            completion(false,nil)
        }
    }
}
