//
//  StorageManagerTests.swift
//  UserDefaultsManagerTests
//
//  Created by Николай on 16.06.2022.
//

import XCTest
@testable import WeightControl

class StorageManagerTests: XCTestCase {

    private var sut: StorageManager!
    
    override func setUp() {
        super.setUp()
        sut = StorageManager.shared
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSaveAndEditWeightData() throws {
        
        sut.deleteAll()
        
        let weightData = WeightData()

        weightData.weightKilo = 100
        weightData.weightGramm = 20
        weightData.date = .now
        weightData.photoData = nil

        sut.save(weightData)
        
        var savedData = sut.getSortedWeightData()
        var firstElement = savedData.first

        XCTAssertEqual(savedData.count, 1)
        XCTAssertEqual(firstElement?.weightKilo, 100)
        XCTAssertEqual(firstElement?.weightGramm, 20)
        
        sut.edit(firstElement!, date: .now, weightKilo: 90, weightGramm: 10)
        
        savedData = sut.getSortedWeightData()
        firstElement = savedData.first

        XCTAssertEqual(savedData.count, 1)
        XCTAssertEqual(firstElement?.weightKilo, 90)
        XCTAssertEqual(firstElement?.weightGramm, 10)
    }
        
}
