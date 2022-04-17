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
        
    private let pickerWidth: CGFloat = 400
    private var viewModel: WeightHistoryViewModelProtocol!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = WeightHistoryViewModel()
        setupElements()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numbersOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: WeightDataCellController.identifier,
            for: indexPath) as! WeightDataCellController
        
        let cellData = viewModel.cellViewModel(at: indexPath.row)
              
        cell.configure(with: cellData)
        
        return cell
    }
        
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let currentWeightData = viewModel.weightDataDetails(at: indexPath.row)
        
        let openAction = UIContextualAction(style: .normal, title: "Open") { _, _, handler in
            self.openWeightData(indexPath.row)
            handler(true)
        }
        
        openAction.backgroundColor = Colors.accent
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, handler in
            self.editWeightData(weightData: currentWeightData)
            handler(true)
        }
        
        editAction.backgroundColor = Colors.edit
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { _, _, handler in
            self.viewModel.deleteWeightData(with: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.updateWeightData()
            handler(true)
        }
        
        deleteAction.backgroundColor = Colors.delete
        
        let result = UISwipeActionsConfiguration(actions: [editAction, openAction, deleteAction])
        
        return result
        
    }
        
    // MARK: - Private methods
    
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
    
    private func openWeightData(_ index: Int? = nil) {
        
        let weightDetails = WeightDataDetailsViewController()
        
        weightDetails.delegate = self
        
        weightDetails.weightData = viewModel.weightDataDetails(at: index)
        weightDetails.lastWeightData = viewModel.lastWeightDataDetails()
        
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
    
    private func setValuesPickerView(
        _ weightData: WeightDataDetailsViewModelProtocol,
        _ datePicker: UIDatePicker,
        _ pickerView: UIPickerView) {
        
        datePicker.date = weightData.date
        
        let weightInKilo = weightData.weightKilo
        let weightInGramm = weightData.weightGramm
        
        pickerView.selectRow(weightInKilo, inComponent: 0, animated: false)
        pickerView.selectRow(weightInGramm, inComponent: 1, animated: false)
    }
    
    private func editWeightData(weightData: WeightDataDetailsViewModelProtocol) {
        
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
            weightData: WeightDataDetailsViewModelProtocol,
            date: Date,
            weightKilo: Int,
            weightGramm: Int) {
            
            weightData.saveData(
                date: date,
                weightKilo: weightKilo,
                weightGramm: weightGramm
            )
                
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
