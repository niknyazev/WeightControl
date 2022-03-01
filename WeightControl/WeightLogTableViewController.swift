//
//  WeightLogTableViewController.swift
//  WeightControl
//
//  Created by Николай on 01.03.2022.
//

import UIKit

struct WeightData {
    let date: Date
    let weight: Int
    let photoData: Data?
}

class WeightLogTableViewController: UITableViewController {
    
    let weightData = [
        WeightData(date: .now, weight: 80, photoData: nil),
        WeightData(date: .now, weight: 83, photoData: nil),
        WeightData(date: .now, weight: 85, photoData: nil),
        WeightData(date: .now, weight: 87, photoData: nil),
        WeightData(date: .now, weight: 88, photoData: nil)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
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
