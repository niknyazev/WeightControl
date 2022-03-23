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

class WeightLogTableViewController: UITableViewController {
    
    // MARK: - Properties
        
    private var weightData: Results<WeightData>!
    private let storageManager = StorageManager.shared
    private let pickerWidth: CGFloat = 400
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightData = storageManager
            .realm.objects(WeightData.self)
            .sorted(byKeyPath: "date", ascending: false)
        tableView.rowHeight = 65
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weightData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weightData", for: indexPath) as! WeightDataCellController
        
        let weightChange = indexPath.row == weightData.count - 1
            ? nil
            : weightData[indexPath.row].weight - weightData[indexPath.row + 1].weight
        
        cell.configure(with: weightData[indexPath.row], weightChange: weightChange)
        
        return cell
    }
        
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, handler in
            self.performSegue(withIdentifier: "weightDetails", sender: self.weightData[indexPath.row])
            handler(true)
        }
        
        let result = UISwipeActionsConfiguration(actions: [editAction])
        
        return result
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "weightDetails" {
            
            guard let navigationController = segue.destination as? UINavigationController,
                  let weightDetails = navigationController.viewControllers.first as? WeightDataDetailsViewController else {
                return
            }
            
            weightDetails.delegate = self
            
            if let weightData = sender as? WeightData {
                weightDetails.weightData = weightData
            } else {
                if !weightData.isEmpty {
                    weightDetails.lastWeightData = weightData.first
                }
            }
        }
        
    }
    
    // MARK: - Private methods
    
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
            height: 260
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

        let photoButton = UIButton()

        photoButton.setTitle("Make photo", for: .normal)
        photoButton.setTitleColor(.tintColor, for: .normal)
        photoButton.backgroundColor = .systemGray5
        photoButton.layer.cornerRadius = 10

        viewController.view.addSubview(datePicker)
        viewController.view.addSubview(pickerView)
        viewController.view.addSubview(photoButton)

        datePicker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor)
            
        ])

        photoButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            photoButton.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            photoButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 5),
            photoButton.widthAnchor.constraint(equalToConstant: 200),
            photoButton.heightAnchor.constraint(equalToConstant: 40)
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

        self.present(alertController, animated: true)
        
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
                weightGramm: weightGramm,
                photoData: nil
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

// MARK: - Updater delegate

extension WeightLogTableViewController: WeightDataUpdaterDelegate {
    func updateWeightData() {
        tableView.reloadData()
                    
        guard let navigationController = self.tabBarController?.viewControllers?[0] as? UINavigationController,
              let chart = navigationController.viewControllers[0] as? ChartViewController
        else { return }
        
        chart.updateChart()
    }
}
