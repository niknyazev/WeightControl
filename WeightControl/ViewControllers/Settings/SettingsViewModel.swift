//
//  SettingsViewModel.swift
//  WeightControl
//
//  Created by Николай on 09.04.2022.
//

import Foundation

protocol SettingsViewModelProtocol {
    func titleForHeader(for section: Int) -> String
    func numbersOfSections() -> Int
    func numbersOfRowsInSection(for section: Int) -> Int
    func cellViewModel(for indexPath: IndexPath ) -> SettingsCellViewModelProtocol
}

protocol SettingsCellViewModelProtocol {
    var values: [String] { get }
    var value: String { get set }
    var title: String { get }
    var isEditableCell: Bool { get }
    var titlePicker: String { get }
}

struct SettingsCellViewModel: SettingsCellViewModelProtocol {
    let values: [String]
    var value: String
    let title: String
    var isEditableCell: Bool
    var titlePicker: String {
        "Choose \(title)"
    }
}

class SettingsViewModel: SettingsViewModelProtocol {

    private var currentWeight: Double = 0
    private var pickerValues: [SettingsCellViewModelProtocol] = []
    private var results: [SettingsCellViewModelProtocol] = []
    private var userData: UserData!
    
    init() {
        fetchData()
        fillSettingsRows()
    }
    
    // MARK: - Public methods
    
    func titleForHeader(for section: Int) -> String {
        section == 0 ? "User data" : "Weights"
    }
    
    func numbersOfSections() -> Int {
        2
    }
    
    func numbersOfRowsInSection(for section: Int) -> Int {
        section == 0 ? pickerValues.count : results.count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> SettingsCellViewModelProtocol {
        indexPath.section == 0 ? pickerValues[indexPath.row] : results[indexPath.row]
    }
    
    // MARK: - Private methods
    
    private func fetchData() {
        userData = UserDefaultsManager.shared.fetchUserData()
        let weightData = StorageManager
            .shared
            .realm
            .objects(WeightData.self)
            .sorted(byKeyPath: "date")
        
        currentWeight = weightData.last?.weight ?? 0
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
    
    private func fillSettingsRows() {
        
        let sexes = [
            UserData.Sex.male.rawValue,
            UserData.Sex.female.rawValue
        ]
        
        pickerValues.append(
            SettingsCellViewModel(
                values: (10...110).map { String($0) },
                value: String(userData.age),
                title: "age",
                isEditableCell: true
           )
        )
                
        pickerValues.append(
            SettingsCellViewModel(
                values: (10...250).map { String($0) },
                value: String(userData.height),
                title: "height",
                isEditableCell: true
            )
        )
        
        pickerValues.append(
            SettingsCellViewModel(
                values: sexes,
                value: userData.sex.rawValue,
                title: "sex",
                isEditableCell: true
            )
        )
        
        pickerValues.append(
            SettingsCellViewModel(
                values: (0...300).map { String($0) },
                value: String(userData.weightGoal),
                title: "weight goal",
                isEditableCell: true
            )
        )
    
        // Results rows
        
        results.append(
            SettingsCellViewModel(
                values: [],
                value: "0",
                title: "Current BMI",
                isEditableCell: false
            )
        )
                
        results.append(
            SettingsCellViewModel(
                values: [],
                value: "0",
                title: "Minimum weight",
                isEditableCell: false
            )
        )
    
        results.append(
            SettingsCellViewModel(
                values: [],
                value: "0",
                title: "Maximum weight",
                isEditableCell: false
            )
        )
    }
    
    private func saveValues() {

//        let userData = UserData(
//            age: Int(pickerValues[0].value) ?? 0,
//            height: Int(pickerValues[1].value) ?? 0,
//            weightGoal: Int(pickerValues[3].value) ?? 0,
//            sex: UserData.Sex(rawValue: pickerValues[2].value) ?? .male
//        )
//
//        userDefaults.saveUserData(userData: userData)
    }
    
}
