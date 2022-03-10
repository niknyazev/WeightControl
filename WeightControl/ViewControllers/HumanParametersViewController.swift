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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()

    }
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectValue(tag: indexPath.row)
    }
    
    // MARK: - Private methods
    
    func selectValue(tag: Int) {
        
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: 250,height: 200)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = tag
        
        viewController.view.addSubview(pickerView)
        
        var chooserTitle = ""
        
        if tag == 0 {
            chooserTitle = "age"
        } else if tag == 1 {
            chooserTitle = "height"
        }
        
        let editRadiusAlert = UIAlertController(title: "Choose \(chooserTitle)", message: "", preferredStyle: .alert)
        
        editRadiusAlert.setValue(viewController, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
       
        self.present(editRadiusAlert, animated: true)
        
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        String(row)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 0 {
            return 110
        } else if pickerView.tag == 1 {
            return 250
        } else {
            return 0
        }
    
    }

}
