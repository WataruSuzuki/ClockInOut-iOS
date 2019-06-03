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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        if let menu = Sections(rawValue: indexPath.section) {
            switch menu {
            case .timeToOn: fallthrough
            case .timeToLeave:
                return pickerCell(menu, cellForRowAt: indexPath)
            case .officeLocation:
                cell.textLabel?.text = String(describing: menu)
                cell.detailTextLabel?.text = LocationService.shared.officeAddress
            }
        }

        return cell
    }
    
    private func pickerCell(_ menu: Sections, cellForRowAt indexPath: IndexPath) -> AUPickerCell {
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
        guard let menu = Sections(rawValue: indexPath.section) else { return }
        switch menu {
        case .officeLocation:
            let alert = UIAlertController(title: "Confirm".localized, message: "UpdateOfficeLocation".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action) in
                LocationService.shared.isUpdateOfficeLocation = true
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
        guard let menu = Sections(rawValue: indexPath.section) else { return }
        switch menu {
        case .timeToOn:
            DiskService.saveTimeTo(on: formattedDateStr)
        case .timeToLeave:
            DiskService.saveTimeTo(leave: formattedDateStr)
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
    
    enum Sections: Int, CaseIterable {
        case officeLocation = 0,
        timeToOn,
        timeToLeave
        
        func savedDate() -> Date? {
            switch self {
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
            return Date.dateFromString(string: saved, timeStyle: .short)
        }
    }
}
