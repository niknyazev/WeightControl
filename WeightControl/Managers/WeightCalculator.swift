//
//  WeightCalculator.swift
//  WeightControl
//
//  Created by Николай on 04.04.2022.
//

import Foundation

// TODO: need refactoring - implement new class, without weight. Weight does not need
// then we calculate min and max weights

class WeightCalculator {
    
    var height: Int
    var weight: Double
    
    static let minimumBmi = 18.5
    static let maximumBmi = 25.0
    
    init(height: Int, weight: Double) {
        self.height = height
        self.weight = weight
    }
    
    func calculateBmi() -> Double {
        let height = Double(self.height) / 100
        let result = weight / (height * height)
        return result
    }
    
    func calculateBestWeights() -> (min: Int, max: Int) {
        
        let minimumBmi = WeightCalculator.minimumBmi
        let maximumBmi = WeightCalculator.maximumBmi
        
        var minimumWeight = 0
        var maximumWeight = 0
        
        for currentWeight in (10...200) {
            
            let calculator = WeightCalculator(
                height: height,
                weight: Double(currentWeight)
            )
            
            let bmi = calculator.calculateBmi()
            
            if bmi > minimumBmi && minimumWeight == 0 {
                minimumWeight = currentWeight - 1
            } else if bmi > maximumBmi && maximumWeight == 0 {
                maximumWeight = currentWeight - 1
            }
            
            if minimumWeight > 0 && maximumWeight > 0 {
                break
            }
        }
        
        return (min: minimumWeight, max: maximumWeight)
    }
    
}
