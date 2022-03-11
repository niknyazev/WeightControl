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
            WeightData()
        ]
        
        return weightData
        
    }
    
}
