//
//  StorageManager.swift
//  WeightControl
//
//  Created by Николай on 01.03.2022.
//

import Foundation

final class StorageManager {
    
    static let shared = StorageManager()
    
    private init() { }
    
    func fetchData() -> [WeightData] {
        
        let weightData = [
            WeightData(date: .now, weight: 80, photoData: nil),
            WeightData(date: .now + 1 * 24 * 3600, weight: 83, photoData: nil),
            WeightData(date: .now + 2 * 24 * 3600, weight: 85, photoData: nil),
            WeightData(date: .now + 3 * 24 * 3600, weight: 87, photoData: nil),
            WeightData(date: .now + 4 * 24 * 3600, weight: 86, photoData: nil),
            WeightData(date: .now + 5 * 24 * 3600, weight: 82, photoData: nil),
            WeightData(date: .now + 6 * 24 * 3600, weight: 80, photoData: nil),
            WeightData(date: .now + 7 * 24 * 3600, weight: 78, photoData: nil),
            WeightData(date: .now + 8 * 24 * 3600, weight: 75, photoData: nil)
        ]
        
        return weightData
        
    }
    
}
