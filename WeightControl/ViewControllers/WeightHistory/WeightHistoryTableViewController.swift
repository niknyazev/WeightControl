//
//  WeightLogTableViewController.swift
//  WeightControl
//
//  Created by Николай on 01.03.2022.
//

import UIKit
import RealmSwift

protocol WeightDataUpdaterDelegate {
    func updateWeightData()
}

class WeightHistoryTableViewController: UITableViewController {
    
    // MARK: - Properties
        
    private var weightData: Results<WeightData>!
    private let storageManager = StorageManager.shared
    private let pickerWidth: CGFloat = 400
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeightData()
        setupElements()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weightData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: WeightDataCellController.identifier,
            for: indexPath) as! WeightDataCellController
        
        let weightChange = indexPath.row == weightData.count - 1
            ? nil
            : weightData[indexPath.row].weight - weightData[indexPath.row + 1].weight
        
        cell.configure(with: weightData[indexPath.row], weightChange: weightChange)
        
        return cell
    }
        
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let currentWeightData = weightData[indexPath.row]
        
        let openAction = UIContextualAction(style: .normal, title: "Open") { _, _, handler in
            self.openWeightData(currentWeightData)
            handler(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, handler in
            self.editWeightData(weightData: currentWeightData)
            handler(true)
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { _, _, handler in
            self.storageManager.delete(currentWeightData)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.updateWeightData()
            handler(true)
        }
        
        let result = UISwipeActionsConfiguration(actions: [editAction, openAction, deleteAction])
        
        return result
        
    }
        
    // MARK: - Private methods
    
    private func fetchWeightData() {
        weightData = storageManager
            .realm.objects(WeightData.self)
            .sorted(byKeyPath: "date", ascending: false)
    }
    
    private func setupElements() {
        title = "History"
        tableView.rowHeight = 65
        tableView.register(WeightDataCellController.self, forCellReuseIdentifier: WeightDataCellController.identifier)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addWeightData)
        )
    }
    
    @objc private func addWeightData() {
        openWeightData()
    }
    
    private func openWeightData(_ currentWeightData: WeightData? = nil) {
        
        let weightDetails = WeightDataDetailsViewController()
        
        weightDetails.delegate = self
        
        if let currentWeightData = currentWeightData {
            weightDetails.weightData = currentWeightData
        } else {
            weightDetails.lastWeightData = weightData.first
        }
        
        present(
            UINavigationController(rootViewController: weightDetails),
            animated: true,
            completion: nil
        )
    }
    
    private func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let result = dateFormatter.string(from: date)
        return result
    }
    
    private func setValuesPickerView(_ weightData: WeightData?, _ datePicker: UIDatePicker, _ pickerView: UIPickerView) {
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
    }
    
    private func editWeightData(weightData: WeightData? = nil) {
        
        let alertController = UIAlertController(
            title: "Select weight value",
            message: "",
            preferredStyle: .actionSheet
        )
        
        let width = alertController.view.bounds.width
        
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(
            width: width,
            height: 210
        )
        
        let datePicker = UIDatePicker(frame: CGRect(
            x: 0,
            y: 0,
            width: width,
            height: 45
        ))
                        
        let pickerView = UIPickerView(frame: CGRect(
            x: 0,
            y: 50,
            width: width,
            height: 150
        ))

        pickerView.delegate = self
        pickerView.dataSource = self

        setValuesPickerView(weightData, datePicker, pickerView)

        viewController.view.addSubview(datePicker)
        viewController.view.addSubview(pickerView)

        datePicker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor)
        ])
        
        let doneAction = UIAlertAction(title: "Done", style: .default) {_ in
            self.saveWeightDataUpdateElements(
                weightData: weightData,
                date: datePicker.date,
                weightKilo: pickerView.selectedRow(inComponent: 0),
                weightGramm: pickerView.selectedRow(inComponent: 1)
            )
        }
        
        alertController.setValue(viewController, forKey: "contentViewController")
        alertController.addAction(doneAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
        
    }
    
    private func saveWeightDataUpdateElements(
        weightData: WeightData?,
        date: Date,
        weightKilo: Int,
        weightGramm: Int) {
        
        if let weightData = weightData {
            storageManager.edit(
                weightData,
                date: date,
                weightKilo: weightKilo,
                weightGramm: weightGramm
            )
        } else {
            let currentWeightData = WeightData()
            
            currentWeightData.weightKilo = weightKilo
            currentWeightData.weightGramm = weightGramm
            currentWeightData.date = date
            
            storageManager.save(currentWeightData)
        }
            
        updateWeightData()
    }
}

// MARK: - PickerView

extension WeightHistoryTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

// MARK: - Updater delegate

extension WeightHistoryTableViewController: WeightDataUpdaterDelegate {
    func updateWeightData() {
        tableView.reloadData()
                    
        guard let navigationController = self.tabBarController?.viewControllers?[0] as? UINavigationController,
              let chart = navigationController.viewControllers[0] as? ChartViewController
        else { return }
        
        chart.updateWeightData()
    }
}
