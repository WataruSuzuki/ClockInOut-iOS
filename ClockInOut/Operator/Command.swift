//
//  Command.swift
//  ClockInOut
//
//  Created by 鈴木 航 on 2019/09/08.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import Foundation
import SwiftyFORM

protocol Command {
    func populate(builder: FormBuilder, sender: FormViewController)
    
    func checkIn(completionHandler: @escaping (_ result: Result<CheckInOutOperation, Error>) -> Void)
    func checkOut(completionHandler: @escaping (_ result: Result<CheckInOutOperation, Error>) -> Void)
}
