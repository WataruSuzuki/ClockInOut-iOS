//
//  LocationService.swift
//  ClockInOut
//
//  Created by 鈴木航 on 2019/09/03.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit
import CoreLocation
import EasyNotification

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
        let moniteringRegion = CLCircularRegion.init(center: moniteringCordinate, radius: 10.0, identifier: "Office".localized)
        
        manager.startMonitoring(for: moniteringRegion)
    }
    
    private func saveOfficeLocation(location: CLLocation) {
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        DiskService.saveOfficeLocation(latitude: latitude!, longitude: longitude!)
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first,
                let name = placemark.name, let locality = placemark.locality, let administrativeArea = placemark.administrativeArea {
                self.address = "\(name), \(locality), \(administrativeArea)"
                DiskService.saveOfficeAddress(address: self.address!)
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
        EasyNotification.shared.schedule(title: region.identifier, body: "StartMonitoring".localized, action: "OK", requestIdentifier: "didStartMonitoringFor")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        CheckInOutService.checkIn()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        CheckInOutService.checkOut()
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        guard let timeToOn = DiskService.timeToOn, let timeToLeave = DiskService.timeToLeave else { return }
        let now = Date()
        let checked = now.formattedString(dateStyle: .medium, timeStyle: .none)

        switch state {
        case .inside:
            guard Date.dateFromString(string: timeToLeave, timeStyle: .short) < now,
                DiskService.lastCheckOutTime != checked else { return }
            EasyNotification.shared.schedule(
                title: "(・∀・)b",
                subTitle: "\(now.formattedString(dateStyle: .none, timeStyle: .short))",
                body: "timeToLeave".localized, action: "OK", requestIdentifier: state.describing
            )
        case .outside:
            guard Date.dateFromString(string: timeToOn, timeStyle: .short) > now,
                DiskService.lastCheckOnTime != checked else { return }
            EasyNotification.shared.schedule(
                title: "(・A・)q",
                subTitle: "\(now.formattedString(dateStyle: .none, timeStyle: .short))",
                body: "timeToOn".localized, action: "OK", requestIdentifier: state.describing
            )
        case .unknown:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error.localizedDescription)
    }
}
