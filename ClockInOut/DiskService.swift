//
//  DiskService.swift
//  ClockInOut
//
//  Created by 鈴木航 on 2019/09/04.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit

class DiskService: NSObject {
    
    private static let key_latitude = "latitude"
    private static let key_longitude = "longitude"
    private static let key_officeAddress = "officeAddress"
    private static let key_timeToOn = "timeToOn"
    private static let key_timeToLeave = "timeToLeave"

    static func loadOfficeLocation() -> (
        officeAddress: String?,
        latitude: Double?,longitude: Double?) {
            let standard = UserDefaults.standard
            return (
                standard.object(forKey: key_officeAddress) as? String,
                standard.object(forKey: key_latitude) as? Double,
                standard.object(forKey: key_longitude) as? Double
            )
    }
    
    static func saveOfficeLocation(latitude: Double, longitude: Double) {
        let standard = UserDefaults.standard
        standard.set(latitude, forKey: key_latitude)
        standard.set(longitude, forKey: key_longitude)
        standard.synchronize()
    }
    
    static func saveOfficeAddress(address: String) {
        let standard = UserDefaults.standard
        standard.set(address, forKey: key_officeAddress)
        standard.synchronize()
    }

    static func saveTimeTo(on: String) {
        let standard = UserDefaults.standard
        standard.set(on, forKey: key_timeToOn)
        standard.synchronize()
    }
    
    static func saveTimeTo(leave: String) {
        let standard = UserDefaults.standard
        standard.set(leave, forKey: key_timeToLeave)
        standard.synchronize()
    }
    
    static var timeToOn: String? {
        get {
            return UserDefaults.standard.object(forKey: key_timeToOn) as? String
        }
    }
    
    static var timeToLeave: String? {
        get {
            return UserDefaults.standard.object(forKey: key_timeToLeave) as? String
        }
    }
}
