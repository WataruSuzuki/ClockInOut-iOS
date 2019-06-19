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
    var operatorType: OperatorType!
    
    override func loadView() {
        super.loadView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tapCancel(sender:)))
    }
    
    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = "SignIn".localized
        builder.toolbarMode = .simple
        builder.demo_showInfo(String(format: "WelcomeTo".localized, operatorType.describing.localized))
        
        // Inject operator dependency...
        operatorType.commander?.populate(builder: builder, sender: self)
        
        builder += SectionFormItem()
        builder += metaData
        builder += saveButton
    }

    lazy var metaData: MetaFormItem = {
        let instance = MetaFormItem()
        instance.value(operatorType.describing as AnyObject).elementIdentifier(String(describing: OperatorType.self))
        return instance
    }()
    
    lazy var saveButton: ButtonFormItem = {
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
            DiskService.operatorInfo = formBuilder.dump()
            dismiss(animated: true, completion: nil)
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
