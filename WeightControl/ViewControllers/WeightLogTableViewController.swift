//
//  WeightLogTableViewController.swift
//  WeightControl
//
//  Created by Николай on 01.03.2022.
//

import UIKit
import RealmSwift

class WeightLogTableViewController: UITableViewController {
    
    // MARK: - Properties
        
    private var weightData: Results<WeightData>!
    private let storageManager = StorageManager.shared
    private let pickerWidth: CGFloat = 250
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightData = storageManager.realm.objects(WeightData.self).sorted(byKeyPath: "date")
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, handler in
            self.editWeightData(weightData: self.weightData[indexPath.row])
            handler(true)
        }
        
        let result = UISwipeActionsConfiguration(actions: [editAction])
        
        return result
        
    }
    
    // MARK: - IBAction methods
    
    @IBAction func addEntryDidPress(_ sender: UIBarButtonItem) {
        editWeightData()
    }
    
    // MARK: - Private methods
    
    private func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let result = dateFormatter.string(from: date)
        return result
    }
    
    private func editWeightData(weightData: WeightData? = nil) {
        
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: pickerWidth, height: 260)
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: 45))
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: pickerWidth, height: 150))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if let weightData = weightData {
            datePicker.date = weightData.date
            
            let weightInKilo = weightData.weightKilo
            let weightInGramm = weightData.weightGramm
            
            pickerView.selectRow(weightInKilo, inComponent: 0, animated: false)
            pickerView.selectRow(weightInGramm, inComponent: 1, animated: false)
            
        } else {
            pickerView.selectRow(60, inComponent: 0, animated: false)
            pickerView.selectRow(0, inComponent: 1, animated: false)
        }
                        
        let photoButton = UIButton(frame: CGRect(x: 0, y: 205, width: pickerWidth, height: 45))
        photoButton.setTitle("Make photo", for: .normal)
        photoButton.setTitleColor(.tintColor, for: .normal)
        
        viewController.view.addSubview(datePicker)
        viewController.view.addSubview(pickerView)
        viewController.view.addSubview(photoButton)
        
        let editRadiusAlert = UIAlertController(title: "Select weight value", message: "", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default) {[unowned self]_ in
            
            if let weightData = weightData {
                storageManager.edit(
                    weightData,
                    date: datePicker.date,
                    weightKilo: pickerView.selectedRow(inComponent: 0),
                    weightGramm: pickerView.selectedRow(inComponent: 1)
                )
            } else {
                let currentWeightData = WeightData()
                
                currentWeightData.weightKilo = pickerView.selectedRow(inComponent: 0)
                currentWeightData.weightGramm = pickerView.selectedRow(inComponent: 1)
                currentWeightData.date = datePicker.date
                
                storageManager.save(currentWeightData)
            }
            
            tableView.reloadData()
                        
            guard let navigationController = self.tabBarController?.viewControllers?[0] as? UINavigationController,
                  let chart = navigationController.viewControllers[0] as? ChartViewController
            else { return }
            
            chart.updateChart()
        }

        editRadiusAlert.setValue(viewController, forKey: "contentViewController")
        editRadiusAlert.addAction(doneAction)
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(editRadiusAlert, animated: true)
        
    }
    
    
}

// MARK: - PickerView

extension WeightLogTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        String(row)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 200
        } else {
            return 10
        }
    }
    
}
