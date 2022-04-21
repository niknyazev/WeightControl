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
    func saveValues()
    func valuesForEditableCell(for row: Int) -> [String]
    func setValueForEditableCell(row: Int, newValueIndex: Int)
}

class SettingsViewModel: SettingsViewModelProtocol {

    private var currentWeight: Double = 0
    private var editableCells: [SettingsCellViewModelProtocol] = []
    private var resultCells: [SettingsCellViewModelProtocol] = []
    private var userData: UserData!
    private let userDefaults = UserDefaultsManager.shared
    
    init() {
        fetchData()
        fillSettingsRows()
        calculateResultCells()
    }
    
    // MARK: - Public methods
    
    func setValueForEditableCell(row: Int, newValueIndex: Int) {
        var currentRow = editableCells[row]
        currentRow.value = currentRow.values[newValueIndex]
        calculateResultCells()
        saveValues()
    }
    
    func valuesForEditableCell(for row: Int) -> [String] {
        editableCells[row].values
    }
    
    func titleForHeader(for section: Int) -> String {
        section == 0 ? "User data" : "Weights"
    }
    
    func numbersOfSections() -> Int {
        2
    }
    
    func numbersOfRowsInSection(for section: Int) -> Int {
        section == 0 ? editableCells.count : resultCells.count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> SettingsCellViewModelProtocol {
        indexPath.section == 0 ? editableCells[indexPath.row] : resultCells[indexPath.row]
    }
    
    func saveValues() {

        let userData = UserData(
            age: Int(editableCells[0].value) ?? 0,
            height: Int(editableCells[1].value) ?? 0,
            weightGoal: Int(editableCells[3].value) ?? 0,
            sex: UserData.Sex(rawValue: editableCells[2].value) ?? .male
        )

        userDefaults.saveUserData(userData: userData)
    }
    
    // MARK: - Private methods
    
    private func fetchData() {
        userData = userDefaults.fetchUserData()
        let weightData = StorageManager
            .shared
            .realm
            .objects(WeightData.self)
            .sorted(byKeyPath: "date")
        
        currentWeight = weightData.last?.weight ?? 0
    }
        
    private func calculateResultCells() {
        
        let heightString = editableCells[1].value
        
        let weightCalculator = WeightCalculator(
            height: Int(heightString) ?? 0,
            weight: currentWeight
        )
        
        let currentBmi = weightCalculator.calculateBmi()
        let bestWeights = weightCalculator.calculateBestWeights()
        
        resultCells[0].value = String(format: "%.2f", currentBmi)
        resultCells[1].value = String(bestWeights.min)
        resultCells[2].value = String(bestWeights.max)
    }
    
    private func fillSettingsRows() {
        
        let sexes = [
            UserData.Sex.male.rawValue,
            UserData.Sex.female.rawValue
        ]
        
        editableCells.append(
            SettingsCellViewModel(
                values: (10...110).map { String($0) },
                value: String(userData.age),
                title: "age",
                isEditable: true
           )
        )
                
        editableCells.append(
            SettingsCellViewModel(
                values: (10...250).map { String($0) },
                value: String(userData.height),
                title: "height",
                isEditable: true
            )
        )
        
        editableCells.append(
            SettingsCellViewModel(
                values: sexes,
                value: userData.sex.rawValue,
                title: "sex",
                isEditable: true
            )
        )
        
        editableCells.append(
            SettingsCellViewModel(
                values: (0...300).map { String($0) },
                value: String(userData.weightGoal),
                title: "weight goal",
                isEditable: true
            )
        )
    
        // Results rows
        
        resultCells.append(
            SettingsCellViewModel(
                values: [],
                value: "0",
                title: "Current BMI",
                isEditable: false
            )
        )
                
        resultCells.append(
            SettingsCellViewModel(
                values: [],
                value: "0",
                title: "Minimum weight",
                isEditable: false
            )
        )
    
        resultCells.append(
            SettingsCellViewModel(
                values: [],
                value: "0",
                title: "Maximum weight",
                isEditable: false
            )
        )
    }
        
}
