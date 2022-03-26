//
//  SettingsViewController.swift
//  WeightControl
//
//  Created by Николай on 09.03.2022.
//

import UIKit

class HumanParametersViewController: UITableViewController {

    // MARK: - Properties
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var weightGoalLabel: UILabel!
    @IBOutlet weak var minumumWeightLabel: UILabel!
    @IBOutlet weak var maximumWeightLabel: UILabel!
    
    private let userDefaults = UserDefaultsManager.shared
    private var pickerValues: [pickerValue] = []
    private let pickerWidth: CGFloat = 250
    private let cellId = "settingData"
    
    typealias pickerValue = (values: [String], title: String)
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillPickerValues()
        setupElements()
        calculateIndicators()
    }
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectValue(tag: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = pickerValues[indexPath.row].title
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pickerValues.count
    }
    
    // MARK: - Private methods
    
    private func calculateIndicators() {
        
        return
        
        guard let heightString = heightLabel.text else { return }
        
        let height = Double(Int(heightString) ?? 0) / 100
        let minimumBmi = 18.5
        let maximumBmi = 25.0
        
        var minimumWeight = 0
        var maximumWeight = 0
        
        for currentWeight in (10...200) {
            
            let bmi = Double(currentWeight) / (height * height)
            
            if bmi > minimumBmi && minimumWeight == 0 {
                minimumWeight = currentWeight - 1
            } else if bmi > maximumBmi && maximumWeight == 0 {
                maximumWeight = currentWeight - 1
            }
            
            if minimumWeight > 0 && maximumWeight > 0 {
                break
            }
        }
        
        minumumWeightLabel.text = String(minimumWeight)
        maximumWeightLabel.text = String(maximumWeight)
        
    }
    
    private func fillPickerValues() {
        
        let sexes = [
            UserData.Sex.male.rawValue,
            UserData.Sex.female.rawValue
        ]
        
        pickerValues.append((values: (10...110).map { String($0) }, title: "age"))
        pickerValues.append((values: (10...250).map { String($0) }, title: "height"))
        pickerValues.append((values: sexes, title: "sex"))
        pickerValues.append((values: (0...300).map { String($0) }, title: "weight goal"))
        
    }
    
    private func selectValue(tag: Int) {
        
//        let viewController = UIViewController()
//        viewController.preferredContentSize = CGSize(width: pickerWidth,height: 200)
//
//        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: 200))
//        pickerView.delegate = self
//        pickerView.dataSource = self
//        pickerView.tag = tag
//
//        let currentValue = pickerValues[tag].element.text ?? ""
//        let currentValueIndex = pickerValues[tag].values.firstIndex(of: currentValue)
//
//        guard let currentValueIndex = currentValueIndex else {
//            return
//        }
//
//        pickerView.selectRow(currentValueIndex, inComponent: 0, animated: false)
//
//        viewController.view.addSubview(pickerView)
//
//        let editRadiusAlert = UIAlertController(title: "Choose \(pickerValues[pickerView.tag].title)", message: "", preferredStyle: .alert)
//
//        editRadiusAlert.setValue(viewController, forKey: "contentViewController")
//        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
//            let currentPicker = self.pickerValues[pickerView.tag]
//            let selectedRow = pickerView.selectedRow(inComponent: 0)
//            currentPicker.element.text = currentPicker.values[selectedRow]
//            self.saveValues()
//            self.calculateIndicators()
//        })
//        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//
//        self.present(editRadiusAlert, animated: true)
        
    }
    
    private func saveValues() {
        
        let userData = UserData(
            age: Int(ageLabel.text ?? "") ?? 0,
            height: Int(heightLabel.text ?? "") ?? 0,
            weightGoal: Int(weightGoalLabel.text ?? "") ?? 0,
            sex: UserData.Sex(rawValue: sexLabel.text ?? "") ?? .male
        )
        
        userDefaults.saveUserData(userData: userData)
        
    }
    
    private func setupElements() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        let userData = userDefaults.fetchUserData()
 
//        ageLabel.text = String(userData.age)
//        heightLabel.text = String(userData.height)
//        sexLabel.text = userData.sex.rawValue
//        weightGoalLabel.text = String(userData.weightGoal)
//
    }

}

// MARK: - Picker view

extension HumanParametersViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
