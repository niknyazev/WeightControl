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
    var note: String { get }
    
    func saveData(date: Date, weightKilo: Int, weightGramm: Int, photoData: Data?, note: String)
    func saveData(date: Date, weightKilo: Int, weightGramm: Int)
}

class WeightDataDetailsViewModel: WeightDataDetailsViewModelProtocol {
    
    var date: Date {
        weightData?.date ?? .now
    }
    
    var weightKilo: Int {
        weightData?.weightKilo ?? kilo
    }
    
    var weightGramm: Int {
        weightData?.weightGramm ?? gram
    }
    
    var photoData: Data? {
        weightData?.photoData
    }
    
    var note: String {
        weightData?.note ?? ""
    }
    
    private let weightData: WeightData?
    private let storageManager = StorageManager.shared
    private var kilo = 80
    private var gram = 0
    
    init(weightData: WeightData? = nil) {
        self.weightData = weightData
    }
    
    convenience init(kilo: Int, gram: Int) {
        self.init()
        self.kilo = kilo
        self.gram = gram
    }
    
    func saveData(date: Date, weightKilo: Int, weightGramm: Int, photoData: Data?, note: String) {
        
        if let weightData = weightData {
            storageManager.edit(
                weightData,
                date: date,
                weightKilo: weightKilo,
                weightGramm: weightGramm,
                photoData: photoData,
                note: note
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
