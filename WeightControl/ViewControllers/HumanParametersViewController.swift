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
        
    // MARK: - Private methods
    
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
