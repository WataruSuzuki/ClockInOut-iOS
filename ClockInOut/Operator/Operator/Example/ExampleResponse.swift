//
//  ExampleResponse.swift
//  ClockInOut
//
//  Created by 鈴木 航 on 2019/09/09.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import Foundation

struct ExampleResponse: Codable {
    let code: Int
    let message: String
    let data: ExampleResponseData
}

struct ExampleResponseData: Codable {
    let id: String
    let username: String
    let token: String
}
