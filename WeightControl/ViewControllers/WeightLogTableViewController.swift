//
//  WeightLogTableViewController.swift
//  WeightControl
//
//  Created by Николай on 01.03.2022.
//

import UIKit

class WeightLogTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var weightData: [WeightData] = []
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightData = StorageManager.shared.fetchData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weightData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weightData", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = weightData[indexPath.row].dateDescription
        content.secondaryText = String(weightData[indexPath.row].weight)
        
        cell.contentConfiguration = content

        return cell
    }
    
    // MARK: - IBAction methods
    
    @IBAction func addEntryDidPress(_ sender: UIBarButtonItem) {
        
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: 250,height: 200)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        viewController.view.addSubview(pickerView)
        
        let editRadiusAlert = UIAlertController(title: "Select weight", message: "", preferredStyle: .alert)

        editRadiusAlert.setValue(viewController, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(editRadiusAlert, animated: true)
        
    }
    
}

// MARK: - PickerView

extension WeightLogTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        200
    }
    
}
