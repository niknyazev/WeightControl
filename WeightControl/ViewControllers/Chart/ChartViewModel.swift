//
//  ChartViewModel.swift
//  WeightControl
//
//  Created by Николай on 09.04.2022.
//

import Foundation
import RealmSwift

protocol ChartViewModelProtocol {
    
    var startWeight: String { get }
    var currentWeight: String { get }
    var remainWeight: String { get }
    var progress: String { get }
    var progressValue: Int { get }
    var weightValues: [Double] { get }
    
    func lastWeightDetailsViewModel() -> WeightDataDetailsViewModel
    func weightDetailsViewModel(for index: Int) -> WeightDataDetailsViewModel
}

class ChartViewModel: ChartViewModelProtocol {
    
    var weightValues: [Double] {
        weightData.map { $0.weight }
    }
    
    var startWeight: String {
        String(weightData.first?.weightKilo ?? 0)
    }
    var currentWeight: String {
        String(weightData.last?.weightKilo ?? 0)
    }
    var remainWeight: String {
        String(currentWeightDifference < 0 ? 0 : currentWeightDifference)
    }
    var progress: String {
        currentWeightDifference < 0 ? "100" : String(progressValue)
    }
    
    var currentWeightDifference: Int {
        (weightData.last?.weightKilo ?? 0) - userData.weightGoal
    }
    var startWeightDifference: Int {
        (weightData.first?.weightKilo ?? 0) - userData.weightGoal
    }
    
    var progressValue: Int {
        let ratio = Double(startWeightDifference - currentWeightDifference)
            / Double(startWeightDifference)
        let result = startWeightDifference == 0
            ? 0
            : Int(ratio * 100)
        return result
    }
    
    private var weightData: Results<WeightData>
    private var userData: UserData
    
    init() {
        weightData = StorageManager.shared.realm.objects(WeightData.self).sorted(byKeyPath: "date")
        userData = UserDefaultsManager.shared.fetchUserData()
    }
    
    func lastWeightDetailsViewModel() -> WeightDataDetailsViewModel {
        if let lastWeightData = weightData.last {
            return WeightDataDetailsViewModel(kilo: lastWeightData.weightKilo, gram: lastWeightData.weightGramm)
        } else {
            return WeightDataDetailsViewModel()
        }
    }
    
    func weightDetailsViewModel(for index: Int) -> WeightDataDetailsViewModel {
        WeightDataDetailsViewModel(weightData: weightData[index])
    }
}
