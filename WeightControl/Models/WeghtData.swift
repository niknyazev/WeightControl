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
    @Persisted var weight: Int = 0
    @Persisted var photoData: Data? = nil
    var dateDescription: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let result = dateFormatter.string(from: date)
        return result
    }
 
}
