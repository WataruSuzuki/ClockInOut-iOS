//
//  ExampleForOperator.swift
//  ClockInOut
//
//  Created by 鈴木 航 on 2019/09/08.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyFORM

class ExampleForOperator: Operator {

    private var email = ""
    private var password = ""
    
    init(data: Data?) {
        super.init()
        guard let data = data, let items = DiskService.convertForm(data: data) else {
            return
        }
        email = ExampleForOperator.value(items, identifier: "ID")
        password = ExampleForOperator.value(items, identifier: "Password")
    }
    
    static private func value(_ items: [FormItem], identifier: String) -> String {
        return items.first(where: {$0.elementIdentifier == identifier})?.value ?? ""
    }
    
    private lazy var userIdForm: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.elementIdentifier = "ID"
        instance.title("User ID").placeholder("Your ID or email, here")
        instance.keyboardType = .emailAddress
        return instance
    }()
    
    private lazy var passwordForm: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.elementIdentifier = "Password"
        instance.title("Password").password().placeholder("required")
        instance.keyboardType = .numbersAndPunctuation
        instance.secureTextEntry = true
        instance.autocorrectionType = .no
        return instance
    }()
        
    override func populate(builder: FormBuilder, sender: FormViewController) {
        builder += SectionHeaderTitleFormItem().title("YourInfo".localized)
        builder += userIdForm
        builder += passwordForm
        builder.alignLeft([userIdForm, passwordForm])
    }

    private func signIn(completionHandler: @escaping (Swift.Result<ExampleStructOperation, Error>) -> Void) {
        let parameters = [:] as [String : Any]
        let url = ""
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess, let data = response.data {
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let json = try jsonDecoder.decode(ExampleResponse.self, from: data)
                    completionHandler(.success(
                        ExampleStructOperation(
                            requestTime: Date(),
                            userId: json.data.id)
                        )
                    )
                } catch let error {
                    completionHandler(.failure(error))
                }

            } else {
                completionHandler(.failure(response.result.error!))
            }
        }
    }
    
    private func check(type: CheckType, operation: ExampleStructOperation, completionHandler: @escaping (Swift.Result<CheckInOutOperation, Error>) -> Void) {
        let parameters = [:] as [String : Any]
        
        let url = ""
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                completionHandler(.success(CheckInOutOperation(requestTime: operation.requestTime)))
            } else {
                completionHandler(.failure(response.result.error!))
            }
        }
    }
    
    override func checkIn(completionHandler: @escaping (Swift.Result<CheckInOutOperation, Error>) -> Void) {
        signIn { (result) in
            switch result {
            case .success(let operation):
                self.check(type: .check_in, operation: operation, completionHandler: completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    override func checkOut(completionHandler: @escaping (Swift.Result<CheckInOutOperation, Error>) -> Void) {
        signIn { (result) in
            switch result {
            case .success(let operation):
                self.check(type: .check_out, operation: operation, completionHandler: completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private enum CheckType: Int {
        case check_in = 0,
        check_out
    }
}
