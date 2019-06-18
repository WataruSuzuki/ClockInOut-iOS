//
//  SettingViewController.swift
//  ClockInOut
//
//  Created by 鈴木航 on 2019/09/03.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit
import AUPickerCell
import SwiftExtensionChimera

class SettingViewController: UITableViewController, AUPickerCellDelegate {

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Settings.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        if let menu = Settings(rawValue: indexPath.section) {
            cell.accessoryType = .none
            cell.textLabel?.text = String(describing: menu).localized
            switch menu {
            case .timeToOn: fallthrough
            case .timeToLeave:
                return pickerCell(menu, cellForRowAt: indexPath)
            case .account:
                cell.accessoryType = .disclosureIndicator
                if let accountInfo = DiskService.accountInfo,
                    let items = DiskService.convertForm(data: accountInfo)
                {
                    cell.detailTextLabel?.text = items.first(where: {$0.elementIdentifier == String(describing: AccountType.self)})?.value
                }
                break
            case .officeLocation:
                cell.detailTextLabel?.text = LocationService.shared.officeAddress
            }
        }

        return cell
    }
    
    private func pickerCell(_ menu: Settings, cellForRowAt indexPath: IndexPath) -> AUPickerCell {
        let cell = AUPickerCell(type: .date, reuseIdentifier: "reuseIdentifier")
        cell.delegate = self
        cell.datePickerMode = .time
        cell.timeStyle = .short
        cell.dateStyle = .none
        cell.leftLabel.text = menu.describing.localized
        if let savedDate = menu.savedDate() {
            cell.setDate(savedDate, animated: false)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menu = Settings(rawValue: indexPath.section) else { return }
        switch menu {
        case .account:
            performSegue(withIdentifier: String(describing: ChooseSignInAccountViewController.self), sender: self)
        case .officeLocation:
            let alert = UIAlertController(title: "Confirm".localized, message: "UpdateOfficeLocation".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action) in
                self.requestToUpdateOfficeLocation()
            }))
            alert.addEmptyCancelAction()
            present(alert, animated: true, completion: nil)
        case .timeToOn:
            fallthrough
        case .timeToLeave:
            if let cell = tableView.cellForRow(at: indexPath) as? AUPickerCell {
                cell.selectedInTableView(tableView)
            }
        }
    }
    
    func requestToUpdateOfficeLocation() {
        LocationService.shared.didUpdate = { (address) in
            let confirm = UIAlertController(title: "Confirm".localized, message: address, preferredStyle: .alert)
            confirm.addEmptyOkAction()
            confirm.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                self.requestToUpdateOfficeLocation()
            }))
            self.present(confirm, animated: true, completion: {
                LocationService.shared.didUpdate = nil
            })
        }
        LocationService.shared.requestUpdateOfficeLocation()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cell = tableView.cellForRow(at: indexPath) as? AUPickerCell {
            return cell.height
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    // MARK: - AUPickerCellDelegate
    
    func auPickerCell(_ cell: AUPickerCell, didPick row: Int, value: Any) {
        guard let date = value as? Date else {
            print(value)
            return
        }
        let formattedDateStr = date.formattedString(dateStyle: .none, timeStyle: .short)
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let menu = Settings(rawValue: indexPath.section) else { return }
        switch menu {
        case .timeToOn:
            DiskService.timeToOn = formattedDateStr
        case .timeToLeave:
            DiskService.timeToLeave = formattedDateStr
        case .account: fallthrough
        case .officeLocation:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Action
    @IBAction
    func tapDone(sender: UIBarButtonItem) {
        guard DiskService.timeToOn != nil, DiskService.timeToLeave != nil else {
            let alert = UIAlertController(title: "Confirm".localized, message: "NotSetYourTimeToOnOrLeave".localized, preferredStyle: .alert)
            alert.addEmptyOkAction()
            present(alert, animated: true, completion: nil)
            return
        }
        dismiss(animated: true, completion: nil)
    }
}
