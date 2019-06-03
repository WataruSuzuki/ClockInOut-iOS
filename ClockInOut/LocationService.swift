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
                let officeLocation = DiskService.loadOfficeLocation()
                guard let latitude = officeLocation.latitude,
                    let longitude = officeLocation.longitude else {
                    return false
                }
                
                self.latitude = latitude
                self.longitude = longitude
                self.address = officeLocation.officeAddress
            }
            return true
        }
    }
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    private var address: String?
    var officeAddress: String {
        get {
            if let address = address, !address.isEmpty {
                return address
            } else {
                return "NoData".localized
            }
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
        DiskService.saveOfficeLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first,
                let name = placemark.name, let locality = placemark.locality, let administrativeArea = placemark.administrativeArea {
                DiskService.saveOfficeAddress(address: "\(name), \(locality), \(administrativeArea)")
            }
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
