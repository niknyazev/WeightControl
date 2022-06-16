//
//  WeightCalculatorTests.swift
//  UserDefaultsManagerTests
//
//  Created by Николай on 16.06.2022.
//

import XCTest
@testable import WeightControl

class WeightCalculatorTests: XCTestCase {
    
    private var sut: WeightCalculator!

    override func setUp() {
        super.setUp()
        sut = WeightCalculator(height: 180, weight: 100)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testBMIForHeight180Weight100() throws {
        
        let bmi = sut.calculateBmi()
        
        XCTAssertTrue(round(bmi * 100) == 3086, "BMI for height 180 is incorrect")
    }
    
    func testMinMaxWeightForHeight180() throws {
        
        let weights = sut.calculateBestWeights()
        let weightsIsCorrect = (weights.min == 59 && weights.max == 81)
        
        XCTAssertTrue(weightsIsCorrect, "Min or Max weight is not correct for height 180")
    }

}
