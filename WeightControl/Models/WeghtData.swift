//
//  WeghtData.swift
//  WeightControl
//
//  Created by Николай on 11.03.2022.
//

import Foundation
import RealmSwift

class WeightData: Object {
    @Persisted var date: Date = .now
    @Persisted var weightKilo: Int = 0
    @Persisted var weightGramm: Int = 0
    @Persisted var photoData: Data? = nil
    
    var weight: Float {
        Float(weightKilo) + Float(weightGramm) / 100
    }
    
    var dateDescription: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let result = dateFormatter.string(from: date)
        return result
    }
 
}
