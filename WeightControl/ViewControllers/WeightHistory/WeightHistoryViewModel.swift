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
    func weightDataDetails(at index: Int) -> WeightDataDetailsViewModelProtocol
    func lastWeightDataDetails() -> WeightDataDetailsViewModelProtocol?
}

class WeightHistoryViewModel: WeightHistoryViewModelProtocol {
    
    var numbersOfRows: Int {
        weightData.count
    }
    
    private var weightData: Results<WeightData>
    private let storageManager = StorageManager.shared

    init() {
        weightData = storageManager
            .realm.objects(WeightData.self)
            .sorted(byKeyPath: "date", ascending: false)
    }
    
    func cellViewModel(at index: Int) -> WeightDataCellViewModelProtocol {
        WeightDataCellViewModel(weightData: weightData[index])
    }
    
    func weightDataDetails(at index: Int) -> WeightDataDetailsViewModelProtocol {
        WeightDataDetailsViewModel(weightData: weightData[index])
    }
    
    func lastWeightDataDetails() -> WeightDataDetailsViewModelProtocol? {
        WeightDataDetailsViewModel(weightData: weightData.last)
    }
    
}
