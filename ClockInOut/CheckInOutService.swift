//
//  CheckInOutService.swift
//  ClockInOut
//
//  Created by 鈴木航 on 2019/09/05.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit
import EasyNotification

class CheckInOutService: NSObject {

    static let timeThreshold = TimeInterval(exactly: 10 * 60)! // 10 minutes
    
    static func checkInThreshold(nominal: String, isOn: Bool) -> Bool {
        let now = Date()
        let next = now.formattedString(dateStyle: .medium, timeStyle: .none)
        
        if (isOn && DiskService.lastCheckOnTime == next)
            || (!isOn && DiskService.lastCheckOutTime == next) {
            return false
        }
        
        let nominalInverval = Date.dateFromString(string: nominal, timeStyle: .short).timeIntervalSince1970
        
        let formattedString = now.formattedString(dateStyle: .none, timeStyle: .short)
        let intervalNow = Date.dateFromString(string: formattedString, timeStyle: .short).timeIntervalSince1970
        
        //return (nominal - timeThreshold)...(nominal + timeThreshold) ~= intervalNow
        let checked = isOn || nominalInverval < intervalNow
        //let checked = isLeave ? nominalInverval < intervalNow : nominalInverval > intervalNow
        if checked {
            if isOn {
                DiskService.lastCheckOnTime = next
            } else {
                DiskService.lastCheckOutTime = next
            }
        }
        
        return checked
    }
    
    static func checkIn() {
        guard let timeToOn = DiskService.timeToOn else { return }
        
        if checkInThreshold(nominal: timeToOn, isOn: true) {
            let formatted = Date().formattedString(dateStyle: .none, timeStyle: .short)
            EasyNotification.shared.schedule(title: "EnterRegion".localized,  body: "\("timeToOn".localized): \(formatted)", action: "OK", requestIdentifier: "EnterRegion")
        }
    }
    
    static func checkOut() {
        guard let timeToLeave = DiskService.timeToLeave else { return }
        
        if checkInThreshold(nominal: timeToLeave, isOn: false) {
            let formatted = Date().formattedString(dateStyle: .none, timeStyle: .short)
            EasyNotification.shared.schedule(title: "ExitRegion".localized,  body: "\("timeToLeave".localized): \(formatted)", action: "OK", requestIdentifier: "ExitRegion")
        }
    }
}
