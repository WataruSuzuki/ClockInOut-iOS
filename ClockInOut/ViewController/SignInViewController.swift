//
//  SignInViewController.swift
//  ClockInOut
//
//  Created by 鈴木航 on 2019/09/06.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit
import SwiftyFORM

class SignInViewController: FormViewController {
    var accountType: AccountType!
    
    override func loadView() {
        super.loadView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tapCancel(sender:)))
    }
    
    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = "SignIn".localized
        builder.toolbarMode = .simple
        builder.demo_showInfo(String(format: "WelcomeTo".localized, accountType.describing.localized))
        builder += SectionHeaderTitleFormItem().title("YourInfo".localized)
        builder += userId
        builder += password
        builder.alignLeft([userId, password])
        builder += SectionFormItem()
        builder += metaData
        builder += jsonButton
    }
    
    lazy var userId: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.elementIdentifier = "ID"
        instance.title("User ID").placeholder("Your ID or email, here")
        instance.keyboardType = .emailAddress
        instance.autocorrectionType = .no
        //instance.validate(CharacterSetSpecification.lowercaseLetters, message: "Must be lowercase letters")
        //instance.submitValidate(CountSpecification.min(6), message: "Length must be minimum 6 letters")
        //instance.validate(CountSpecification.max(8), message: "Length must be maximum 8 letters")
        return instance
    }()
    
    lazy var password: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.elementIdentifier = "Password"
        instance.title("Password").password().placeholder("required")
        instance.keyboardType = .numbersAndPunctuation
        instance.secureTextEntry = true
        instance.autocorrectionType = .no
        //instance.validate(CharacterSetSpecification.decimalDigits, message: "Must be digits")
        //instance.submitValidate(CountSpecification.min(4), message: "Length must be minimum 4 digits")
        //instance.validate(CountSpecification.max(6), message: "Length must be maximum 6 digits")
        return instance
    }()
    
    lazy var metaData: MetaFormItem = {
        let instance = MetaFormItem()
        instance.value(accountType.describing as AnyObject).elementIdentifier(String(describing: AccountType.self))
        return instance
    }()
    
    lazy var jsonButton: ButtonFormItem = {
        let instance = ButtonFormItem()
        instance.title = "SignIn".localized
        instance.action = { [weak self] in
            if let vc = self {
                vc.saveAccountInformation()
                //DebugViewController.showJSON(vc, jsonData: vc.formBuilder.dump())
            }
        }
        return instance
    }()
    
    @objc
    func saveAccountInformation() {
        let result = formBuilder.validate()
        switch result {
        case .valid:
            do {
                let jsonData = formBuilder.dump() //try JSONSerialization.data(withJSONObject: value, options: [])
                DiskService.accountInfo = jsonData
                
                let items = try JSONDecoder().decode([FormItem].self, from: jsonData)
                items.forEach { (item) in
                    if let element = item.elementIdentifier {
                        print("element: \(element), value = \(item.value!)")
                    }
                }
                dismiss(animated: true, completion: nil)

            } catch let error {
                print(error)
            }
        case let .invalid(item, message):
            let title = item.elementIdentifier ?? "Invalid"
            form_simpleAlert(title, message)
        }
    }
    
    @objc
    func tapCancel(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
