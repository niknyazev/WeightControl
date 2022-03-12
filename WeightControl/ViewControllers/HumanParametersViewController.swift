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
    
    private let userDefaults = UserDefaultsManager.shared
    private var pickerValues: [pickerValue] = []
    private let pickerWidth: CGFloat = 250
    
    typealias pickerValue = (values: [String], title: String, element: UILabel)
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillPickerValues()
        setupElements()

    }
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectValue(tag: indexPath.row)
    }
    
    // MARK: - Private methods
    
    func fillPickerValues() {
        
        let sexes = [
            UserData.Sex.male.rawValue,
            UserData.Sex.female.rawValue
        ]
        
        pickerValues.append((values: (10...500).map { String($0) }, title: "age", element: ageLabel))
        pickerValues.append((values: (10...110).map { String($0) }, title: "height", element: heightLabel))
        pickerValues.append((values: sexes, title: "sex", element: sexLabel))
        pickerValues.append((values: (0...200).map { String($0) }, title: "weight goal", element: weightGoalLabel))
        
    }
    
    private func selectValue(tag: Int) {
        
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: pickerWidth,height: 200)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = tag
        
        viewController.view.addSubview(pickerView)
        
        let editRadiusAlert = UIAlertController(title: "Choose \(pickerValues[pickerView.tag].title)", message: "", preferredStyle: .alert)
        
        editRadiusAlert.setValue(viewController, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            let currentPicker = self.pickerValues[pickerView.tag]
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            currentPicker.element.text = currentPicker.values[selectedRow]
            self.saveValues()
        })
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
       
        self.present(editRadiusAlert, animated: true)
        
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
        
        let userData = userDefaults.fetchUserData()
        
        guard let userData = userData else {
            return
        }
 
        ageLabel.text = String(userData.age)
        heightLabel.text = String(userData.height)
        sexLabel.text = userData.sex.rawValue
        weightGoalLabel.text = String(userData.weightGoal)
        
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
