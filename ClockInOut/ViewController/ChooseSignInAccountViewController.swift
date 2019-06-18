//
//  ChooseSignInAccountViewController.swift
//  ClockInOut
//
//  Created by 鈴木 航 on 2019/09/08.
//  Copyright © 2019 WataruSuzuki. All rights reserved.
//

import UIKit

class ChooseSignInAccountViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AccountType.allCases.count - 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        if let menu = AccountType(rawValue: indexPath.row + 1), menu != .unknown {
            cell.textLabel?.text = menu.describing.localized
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menu = AccountType(rawValue: indexPath.row + 1), menu != .unknown else { return }
        
        let signIn = SignInViewController()
        signIn.accountType = menu
        let navigation = UINavigationController(rootViewController: signIn)
        present(navigation, animated: true) {
            self.navigationController?.popViewController(animated: false)
        }
    }
}
