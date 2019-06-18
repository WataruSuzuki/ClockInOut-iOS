//
//  Settings.swift
//  ClockInOut
//
//  Created by 鈴木 航 on 2019/09/08.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import Foundation

enum Settings: Int, CaseIterable {
    case account = 0,
    officeLocation,
    timeToOn,
    timeToLeave
    
    func savedDate() -> Date? {
        switch self {
        case .account: fallthrough
        case .officeLocation:
            break
        case .timeToOn:
            return formatted(saved: DiskService.timeToOn)
        case .timeToLeave:
            return formatted(saved: DiskService.timeToLeave)
        }
        return nil
    }
    
    private func formatted(saved: String?) -> Date? {
        guard let saved = saved else { return nil }
        return saved.dateFromString(timeStyle: .short)
    }
}
