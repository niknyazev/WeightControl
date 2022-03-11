//
//  WeghtData.swift
//  WeightControl
//
//  Created by Николай on 11.03.2022.
//

import Foundation

struct WeightData {
    let date: Date
    let weight: Int
    let photoData: Data?
    var dateDescription: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let result = dateFormatter.string(from: date)
        return result
    }
 
}
