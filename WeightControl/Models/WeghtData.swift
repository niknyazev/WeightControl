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
    @Persisted var note: String = ""
    
    var weight: Double {
        Double(weightKilo) + Double(weightGramm) / 100
    }
    
    var weightDescription: String {
        String(format: "%.2f kg", weight)
    }
    
    var dateDescription: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let result = dateFormatter.string(from: date)
        return result
    }
    
    var dateDescriptionShort: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "dd MMM"
        
        let result = dateFormatter.string(from: date)
        return result
    }
}
