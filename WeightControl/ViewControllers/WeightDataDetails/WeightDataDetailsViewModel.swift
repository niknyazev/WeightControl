//
//  WeightDataDetailsViewModel.swift
//  WeightControl
//
//  Created by Николай on 09.04.2022.
//

import Foundation

protocol WeightDataDetailsViewModelProtocol {
    
    var date: Date { get }
    var weightKilo: Int { get }
    var weightGramm: Int { get }
    var photoData: Data? { get }
    var description: String { get }
    
    func saveData(date: Date, weightKilo: Int, weightGramm: Int, photoData: Data?)
    func saveData(date: Date, weightKilo: Int, weightGramm: Int)
}

class WeightDataDetailsViewModel: WeightDataDetailsViewModelProtocol {
    
    var date: Date {
        weightData?.date ?? .now
    }
    
    var weightKilo: Int {
        weightData?.weightKilo ?? 70
    }
    
    var weightGramm: Int {
        weightData?.weightGramm ?? 0
    }
    
    var photoData: Data? {
        weightData?.photoData
    }
    
    var description: String {
        weightData?.description ?? ""
    }
    
    private let weightData: WeightData?
    private let storageManager = StorageManager.shared
    
    init(weightData: WeightData? = nil) {
        self.weightData = weightData ?? WeightData()
    }
    
    func saveData(date: Date, weightKilo: Int, weightGramm: Int, photoData: Data?) {
        
        if let weightData = weightData {
            storageManager.edit(
                weightData,
                date: date,
                weightKilo: weightKilo,
                weightGramm: weightGramm,
                photoData: photoData
            )
        } else {
            let currentWeightData = WeightData()
            
            currentWeightData.weightKilo = weightKilo
            currentWeightData.weightGramm = weightGramm
            currentWeightData.date = date
            currentWeightData.photoData = photoData
            
            storageManager.save(currentWeightData)
        }
    }
    
    func saveData(date: Date, weightKilo: Int, weightGramm: Int) {
        
        guard let weightData = weightData else {
            return
        }
        
        storageManager.edit(
            weightData,
            date: date,
            weightKilo: weightKilo,
            weightGramm: weightGramm
        )
    }
}
