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

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }

        print("save keychain\(location)")
        // Obtener la ubicación actualizada
        // Puedes realizar las acciones relacionadas con la ubicación aquí
        // print(location)
    }
}
