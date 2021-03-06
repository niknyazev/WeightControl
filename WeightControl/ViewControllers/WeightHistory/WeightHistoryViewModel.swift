//
//  WeightHistoryViewModel.swift
//  WeightControl
//
//  Created by Николай on 09.04.2022.
//

import Foundation
import RealmSwift

protocol WeightHistoryViewModelProtocol {
    
    var numbersOfRows: Int { get }
    
    func cellViewModel(at index: Int) -> WeightDataCellViewModelProtocol
    func weightDataDetails(at index: Int?) -> WeightDataDetailsViewModelProtocol
    func deleteWeightData(with index: Int)
}

class WeightHistoryViewModel: WeightHistoryViewModelProtocol {
    
    var numbersOfRows: Int {
        weightData.count
    }
    
    private var weightData: Results<WeightData>
    private let storageManager = StorageManager.shared

    init() {
        weightData = storageManager.getSortedWeightData(ascending: false)
    }
    
    func deleteWeightData(with index: Int) {
        let currentWeightData = weightData[index]
        storageManager.delete(currentWeightData)
    }
    
    func cellViewModel(at index: Int) -> WeightDataCellViewModelProtocol {
        
        var lastWeight: Double? = nil
        
        if index < weightData.count - 1 {
            lastWeight = weightData[index + 1].weight
        }
        return WeightDataCellViewModel(
            weightData: weightData[index],
            lastWeight: lastWeight
        )
    }
    
    func weightDataDetails(at index: Int?) -> WeightDataDetailsViewModelProtocol {
        
        var result = WeightDataDetailsViewModel()
        
        if let index = index {
            result = WeightDataDetailsViewModel(weightData: weightData[index])
        } else if let lastData = weightData.first {
            result = WeightDataDetailsViewModel(
                kilo: lastData.weightKilo,
                gram: lastData.weightGramm
            )
        }
        
        return result
    }
}
