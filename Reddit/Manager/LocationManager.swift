//
//  ManagerLocation.swift
//  Reddit
//
//  Created by Agustin on 08/06/2023.
//

import UIKit
import CoreLocation

final class LocationPermissionManager: NSObject {

    static let shared = LocationPermissionManager()
    private let locationManager = CLLocationManager()
    private var completion: ((CLAuthorizationStatus) -> Void)?

    func requestLocationPermission(completion: @escaping (CLAuthorizationStatus) -> Void) {
        self.completion = completion

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        completion(locationManager.authorizationStatus)
    }

}

extension LocationPermissionManager: CLLocationManagerDelegate {
 
}
