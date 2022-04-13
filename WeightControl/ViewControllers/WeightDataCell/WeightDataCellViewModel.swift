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
    var weightChange: String? { get }
    var isDecline: Bool { get }
}

class WeightDataCellViewModel: WeightDataCellViewModelProtocol {
    
    var weightChange: String?
    var isDecline: Bool
    
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
    
    init(weightData: WeightData, lastWeight: Double? = nil) {
        self.weightData = weightData
        if let lastWeight = lastWeight {
            let weightChange = weightData.weight - lastWeight
            isDecline = weightChange < 0
            let prefix = isDecline ? "-" : "+"
            self.weightChange = prefix + String(format: "%.2f", weightChange)
        } else {
            isDecline = false
        }
    }
}
