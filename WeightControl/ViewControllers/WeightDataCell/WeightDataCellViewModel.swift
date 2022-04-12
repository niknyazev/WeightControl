//
//  WeightDataCellViewModel.swift
//  WeightControl
//
//  Created by Николай on 09.04.2022.
//

import Foundation

protocol WeightDataCellViewModelProtocol {
    var date: String { get }
    var weight: String { get }
    var hasPicture: Bool { get }
    var weightChange: Double? { get }
}

class WeightDataCellViewModel: WeightDataCellViewModelProtocol {
    
    var weightChange: Double? = 0
    
    var date: String {
        weightData.dateDescription
    }
    
    var weight: String {
        weightData.weightDescription
    }
    
    var hasPicture: Bool {
        weightData.photoData != nil
    }
    
    private let weightData: WeightData
    
    init(weightData: WeightData) {
        self.weightData = weightData
    }
}
