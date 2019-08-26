//
//  HypeTableViewController.swift
//  Hype
//
//  Created by Michael Moore on 8/26/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

import UIKit

class HypeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)

        return cell
    }
}
