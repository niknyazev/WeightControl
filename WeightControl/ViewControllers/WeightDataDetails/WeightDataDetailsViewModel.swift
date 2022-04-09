//
//  WeightDataDetailsViewModel.swift
//  WeightControl
//
//  Created by Николай on 09.04.2022.
//

import Foundation

protocol WeightDataDetailsViewModelProtocol {
    var date: Date { get }
    var weight: Double { get }
    var photoData: Data? { get }
    var description: String { get }
}

class WeightDataDetailsViewModel: WeightDataDetailsViewModelProtocol {
    
    var date: Date {
        weightData.date
    }
    
    var weight: Double {
        weightData.weight
    }
    
    var photoData: Data? {
        weightData.photoData
    }
    
    var description: String {
        weightData.description
    }
    
    private let weightData: WeightData
    
    init(weightData: WeightData) {
        self.weightData = weightData
    }
    
}
