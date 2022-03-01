//
//  WeightLogTableViewController.swift
//  WeightControl
//
//  Created by Николай on 01.03.2022.
//

import UIKit

class WeightLogTableViewController: UITableViewController {
    
    var weightData: [WeightData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightData = StorageManager.shared.fetchData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weightData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weightData", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = weightData[indexPath.row].date.description
        content.secondaryText = String(weightData[indexPath.row].weight)
        
        cell.contentConfiguration = content

        return cell
    }

}
