//
//  WeightDataDetailsViewModelTests.swift
//  UserDefaultsManagerTests
//
//  Created by Николай on 21.06.2022.
//

import XCTest
@testable import WeightControl

class WeightDataDetailsViewModelTests: XCTestCase {

    private var sut: WeightDataDetailsViewModel!

    override func setUp() {
        super.setUp()
        sut = WeightDataDetailsViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSaveWeightData() throws {
        sut.saveData(date: .now, weightKilo: 100, weightGramm: 10)
    }
    
}
