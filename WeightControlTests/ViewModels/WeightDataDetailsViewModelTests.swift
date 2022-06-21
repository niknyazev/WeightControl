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
    private let storageManager = StorageManager.shared

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSaveWeightData() throws {

        storageManager.deleteAll()
        
        sut = WeightDataDetailsViewModel()
        
        sut.saveData(date: .now, weightKilo: 100, weightGramm: 10, photoData: nil, note: "Test data")
        let entriesCount = storageManager.getSortedWeightData().count

        XCTAssertEqual(entriesCount, 1)
    }
    
    func testWeightDataValuesAreCorrect() throws {
        
        let weightData = WeightData()
        
        let nowDate = Date.now

        weightData.weightKilo = 100
        weightData.weightGramm = 20
        weightData.date = nowDate
        weightData.photoData = nil
        weightData.note = "Test data"

        storageManager.save(weightData)
        
        sut = WeightDataDetailsViewModel(weightData: weightData)
        
        XCTAssertEqual(sut.weightKilo, 100)
        XCTAssertEqual(sut.weightGramm, 20)
        XCTAssertEqual(sut.date, nowDate)
        XCTAssertEqual(sut.note, "Test data")
    }
}
