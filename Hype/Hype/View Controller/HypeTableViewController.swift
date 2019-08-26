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
        loadData()
    }
    
    func loadData() {
        HypeController.shared.fetchHypes { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func presentAddHypeButton() {
        let alertController = UIAlertController(title: "Get Hype", message: "What is Hype may never die", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "What's hyping today bruh??"
        }
        // 'Add' action
        let addHypeAction = UIAlertAction(title: "Add Hype", style: .default) { (_) in
            // get the text from the textField
            guard let hypeText = alertController.textFields?.first?.text else { return }
            // if the textField isn't empty, save the text to the cloud
            if !hypeText.isEmpty {
                HypeController.shared.saveHype(with: hypeText, completion: { (success) in
                    // if it successfully saves, reload the table view
                    if success {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
        // 'Cancel' Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        // add actions to alertController and present them
        alertController.addAction(addHypeAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HypeController.shared.hypes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)

        let hype = HypeController.shared.hypes[indexPath.row]
        cell.textLabel?.text = hype.hypeText
        cell.detailTextLabel?.text = "\(hype.timestamp)"
        
        return cell
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAddHypeButton()
    }
}
