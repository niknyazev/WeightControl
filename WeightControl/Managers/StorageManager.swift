//
//  StorageManager.swift
//  WeightControl
//
//  Created by Николай on 01.03.2022.
//

import Foundation

struct WeightData {
    let date: Date
    let weight: Int
    let photoData: Data?
}

final class StorageManager {
    
    static let shared = StorageManager()
    
    private init() { }
    
    func fetchData() -> [WeightData] {
        
        let weightData = [
            WeightData(date: .now, weight: 80, photoData: nil),
            WeightData(date: .now, weight: 83, photoData: nil),
            WeightData(date: .now, weight: 85, photoData: nil),
            WeightData(date: .now, weight: 87, photoData: nil),
            WeightData(date: .now, weight: 88, photoData: nil)
        ]
        
        return weightData
        
    }
    
}
