//
//  SettingsViewController.swift
//  WeightControl
//
//  Created by Николай on 09.03.2022.
//

import UIKit

class SettingsViewController: UITableViewController {

    struct SettingRow {
        let values: [String]
        var value: String
        let title: String
    }
    
    // MARK: - Properties
    
    private let userDefaults = UserDefaultsManager.shared
    private var pickerValues: [SettingRow] = []
    private var results: [SettingRow] = []
    private let pickerWidth: CGFloat = 250
    private let cellId = "settingData"
    private var userData: UserData!
    private var currentWeight: Double = 0
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        fillTableWithRowSettings()
        setupElements()
        calculateIndicators()
    }
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "User data" : "Weights"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectValue(tag: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value2, reuseIdentifier: nil)
        var content = cell.defaultContentConfiguration()
        
        if indexPath.section == 0 {
            content.text = pickerValues[indexPath.row].title
           
            let valueText = pickerValues[indexPath.row].value

            content.secondaryAttributedText = NSAttributedString(
                string: valueText,
                attributes: [.foregroundColor: Colors.title]
            )
        } else {
            content.text = results[indexPath.row].title
           
            let valueText = results[indexPath.row].value

            content.secondaryAttributedText = NSAttributedString(
                string: valueText,
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
        return section == 0 ? pickerValues.count : results.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    // MARK: - Private methods
    
    private func fetchData() {
        userData = userDefaults.fetchUserData()
        setCurrentWeight()
    }
    
    private func calculateIndicators() {
        
        let heightString = pickerValues[1].value
        
        let weightCalculator = WeightCalculator(
            height: Int(heightString) ?? 0,
            weight: currentWeight
        )
        
        let currentBmi = weightCalculator.calculateBmi()
        let bestWeights = weightCalculator.calculateBestWeights()
        
        results[0].value = String(format: "%.2f", currentBmi)
        results[1].value = String(bestWeights.max)
        results[2].value = String(bestWeights.max)
    }
    
    private func setCurrentWeight() {
        // TODO: move to class
        let weightData = StorageManager.shared.realm.objects(WeightData.self).sorted(byKeyPath: "date")
        currentWeight = weightData.last?.weight ?? 0
    }
    
    private func fillTableWithRowSettings() {
        
        let sexes = [
            UserData.Sex.male.rawValue,
            UserData.Sex.female.rawValue
        ]
        
        pickerValues.append(
            SettingRow(
                values: (10...110).map { String($0) },
                value: String(userData.age),
                title: "age"
           )
        )
                
        pickerValues.append(
            SettingRow(
                values: (10...250).map { String($0) },
                value: String(userData.height),
                title: "height"
            )
        )
        
        pickerValues.append(
            SettingRow(
                values: sexes,
                value: userData.sex.rawValue,
                title: "sex"
            )
        )
        
        pickerValues.append(
            SettingRow(
                values: (0...300).map { String($0) },
                value: String(userData.weightGoal),
                title: "weight goal"
            )
        )
    
        // Results rows
        
        results.append(
            SettingRow(
                values: [],
                value: "0",
                title: "Current BMI"
            )
        )
                
        results.append(
            SettingRow(
                values: [],
                value: "0",
                title: "Minimum weight"
            )
        )
    
        results.append(
            SettingRow(
                values: [],
                value: "0",
                title: "Maximum weight"
            )
        )
    }
    
    private func selectValue(tag: Int) {
        
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: pickerWidth, height: 170)

        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: 170))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = tag

        let currentValue = pickerValues[tag].value
        let currentValueIndex = pickerValues[tag].values.firstIndex(of: currentValue)

        guard let currentValueIndex = currentValueIndex else {
            return
        }

        pickerView.selectRow(currentValueIndex, inComponent: 0, animated: false)

        viewController.view.addSubview(pickerView)

        let editRadiusAlert = UIAlertController(title: "Choose \(pickerValues[pickerView.tag].title)", message: "", preferredStyle: .alert)

        editRadiusAlert.setValue(viewController, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            self.setSelectedValue(selectedRow: pickerView.selectedRow(inComponent: 0), tag: tag)
        })
        
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(editRadiusAlert, animated: true)
    }
    
    private func setSelectedValue(selectedRow: Int, tag: Int) {
        pickerValues[tag].value
            = pickerValues[tag].values[selectedRow]
        
        saveValues()
        calculateIndicators()
        tableView.reloadData()
    }
    
    private func saveValues() {
        
        let userData = UserData(
            age: Int(pickerValues[0].value) ?? 0,
            height: Int(pickerValues[1].value) ?? 0,
            weightGoal: Int(pickerValues[3].value) ?? 0,
            sex: UserData.Sex(rawValue: pickerValues[2].value) ?? .male
        )

        userDefaults.saveUserData(userData: userData)
    }
    
    private func setupElements() {
        title = "Settings"
        tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    }

}

// MARK: - Picker view

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        pickerWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerValues[pickerView.tag].values[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues[pickerView.tag].values.count
    }

}
