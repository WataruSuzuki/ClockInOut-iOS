//
//  Operator.swift
//  ClockInOut
//
//  Created by 鈴木 航 on 2019/09/08.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit
import SwiftyFORM

class Operator: NSObject,
    Command
{
    func populate(builder: FormBuilder, sender: FormViewController) {
        fatalError("You don't override \(#function) yet...")
    }
    
    func checkIn(completionHandler: @escaping (_ result: Result<CheckInOutOperation, Error>) -> Void) {
        fatalError("You don't override \(#function) yet...")
    }
    
    func checkOut(completionHandler: @escaping (_ result: Result<CheckInOutOperation, Error>) -> Void) {
        fatalError("You don't override \(#function) yet...")
    }
}
