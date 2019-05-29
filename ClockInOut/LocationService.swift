//
//  LocationService.swift
//  ClockInOut
//
//  Created by 鈴木航 on 2019/09/03.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit
import CoreLocation

class LocationService: NSObject,
    CLLocationManagerDelegate
{
    static let shared: LocationService = {
        return LocationService()
    }()
    let manager = CLLocationManager()
    var isUpdateOfficeLocation = false
    var hasOfficeLocation: Bool {
        get {
            if latitude == nil || longitude == nil {
                let standard = UserDefaults.standard
                guard let latitude = standard.object(forKey: "latitude") as? Double,
                    let longitude = standard.object(forKey: "longitude") as? Double else {
                    return false
                }
                
                self.latitude = latitude
                self.longitude = longitude
            }
            return true
        }
    }
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    var officeAddress: String {
        get {
            let standard = UserDefaults.standard
            guard let officeAddress = standard.object(forKey: "officeAddress") as? String else {
                return ""
            }
            return officeAddress
        }
    }

    private override init() {
        super.init()
        manager.delegate = self
        
        handleAuthorizationStatus(status: CLLocationManager.authorizationStatus())
    }
    
    func start() {
        guard hasOfficeLocation else { return }
        
        let moniteringCordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        let moniteringRegion = CLCircularRegion.init(center: moniteringCordinate, radius: 1000.0, identifier: "Office")
        
        manager.startMonitoring(for: moniteringRegion)
    }
    
    private func saveOfficeLocation(location: CLLocation) {
        let standard = UserDefaults.standard
        standard.set(location.coordinate.latitude, forKey: "latitude")
        standard.set(location.coordinate.longitude, forKey: "longitude")
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first,
                let name = placemark.name, let locality = placemark.locality, let administrativeArea = placemark.administrativeArea {
                standard.set("\(name), \(locality), \(administrativeArea)", forKey: "officeAddress")
            }
            standard.synchronize()
        }
    }
    
    private func handleAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .denied: fallthrough
        case .authorizedWhenInUse: fallthrough
        case .restricted:
            break
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .authorizedAlways:
            manager.startUpdatingLocation()
        @unknown default:
            fatalError()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            if isUpdateOfficeLocation {
                saveOfficeLocation(location: location)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("\(#function) state: \(state), region: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error.localizedDescription)
    }
}
