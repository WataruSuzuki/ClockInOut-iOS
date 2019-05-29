//
//  SettingViewController.swift
//  ClockInOut
//
//  Created by 鈴木航 on 2019/09/03.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

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
            cell.textLabel?.text = String(describing: menu)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menu = Sections(rawValue: indexPath.section) else { return }
        switch menu {
        case .officeLocation:
            let alert = UIAlertController(title: "confirm", message: "updateOfficeLocation", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "yes", style: .default, handler: { (action) in
                LocationService.shared.isUpdateOfficeLocation = true
            }))
            present(alert, animated: true, completion: nil)
        case .timeToOn:
            fallthrough
        case .timeToLeave:
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
        dismiss(animated: true, completion: nil)
    }
    
    enum Sections: Int, CaseIterable {
        case officeLocation = 0,
        timeToOn,
        timeToLeave
    }
}
