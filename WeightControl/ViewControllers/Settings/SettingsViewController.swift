//
//  SettingsViewController.swift
//  WeightControl
//
//  Created by Николай on 09.03.2022.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    // MARK: - Properties
        
    private let pickerWidth: CGFloat = 250
    private let cellId = "settingData"
    private var viewModel: SettingsViewModelProtocol!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingsViewModel()
        setupElements()
    }
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titleForHeader(for: section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       selectValue(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value2, reuseIdentifier: nil)
        var content = cell.defaultContentConfiguration()
        
        let cellData = viewModel.cellViewModel(for: indexPath)
        
        content.text = cellData.title
       
        if cellData.isEditable {
            content.secondaryAttributedText = NSAttributedString(
                string: cellData.value,
                attributes: [.foregroundColor: Colors.title]
            )
        } else {
            content.secondaryAttributedText = NSAttributedString(
                string: cellData.value,
                attributes: [
                    .foregroundColor: UIColor.black,
                    .font: UIFont.systemFont(ofSize: 17, weight: .bold)
                ]
            )
        }

        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numbersOfRowsInSection(for: section)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numbersOfSections()
    }
    
    // MARK: - Private methods
        
    private func selectValue(indexPath: IndexPath) {
        
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: pickerWidth, height: 170)

        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: 170))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = indexPath.row

        let currentCell = viewModel.cellViewModel(for: indexPath)
        
        let currentValue = currentCell.value
        let currentValueIndex = currentCell.values.firstIndex(of: currentValue) // TODO: extract to method

        guard let currentValueIndex = currentValueIndex else {
            return
        }

        pickerView.selectRow(currentValueIndex, inComponent: 0, animated: false)

        viewController.view.addSubview(pickerView)

        let editRadiusAlert = UIAlertController(
            title: currentCell.titlePicker,
            message: "",
            preferredStyle: .alert
        )

        editRadiusAlert.setValue(viewController, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            self.setSelectedValue(
                selectedRow: pickerView.selectedRow(inComponent: 0),
                tag: indexPath.row
            )
        })

        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(editRadiusAlert, animated: true)
    }
    
    private func setSelectedValue(selectedRow: Int, tag: Int) {
        viewModel.setValueForEditableCell(row: tag, newValueIndex: selectedRow)
        tableView.reloadData()
        updateChartScene()
    }
    
    private func setupElements() {
        title = "Settings"
        tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    }
    
    private func updateChartScene() {

        guard let navigationController = self.tabBarController?.viewControllers?[0] as? UINavigationController,
              let chart = navigationController.viewControllers[0] as? ChartViewController
        else { return }
        
        chart.updateWeightData()
    }

}

// MARK: - Picker view

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        pickerWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.valuesForEditableCell(for: pickerView.tag)[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.valuesForEditableCell(for: pickerView.tag).count
    }

}
