//
//  AccountType.swift
//  ClockInOut
//
//  Created by 鈴木 航 on 2019/09/08.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import Foundation

enum OperatorType: Int, CaseIterable {
    case unknown = 0,
    hogefuga
    
    init?(name: String) {
        switch name {
        case "hogefuga": self = .hogefuga
        default: self = .unknown
        }
    }
    
    var commander: Operator? {
        get {
            switch self {
            case .hogefuga: return ExampleForOperator(data: DiskService.operatorInfo)
            case .unknown: return nil
            }
        }
    }
    
}
