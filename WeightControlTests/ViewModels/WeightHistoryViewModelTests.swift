//
//  WeightHistoryViewModelTests.swift
//  WeightControlTests
//
//  Created by Николай on 22.06.2022.
//

import XCTest
@testable import WeightControl

class WeightHistoryViewModelTests: XCTestCase {

    private var sut: WeightHistoryViewModelProtocol!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests
    
    func testDeleteWeightData() throws {
        
        saveWeightData()
        
        sut = WeightHistoryViewModel()
        
        XCTAssertEqual(sut.numbersOfRows, 2)
       
        sut.deleteWeightData(with: 0)
        
        XCTAssertEqual(sut.numbersOfRows, 1)
    }

    // MARK: - Private methods
    
    private func saveWeightData() {
        
        let storageManager = StorageManager.shared
        
        storageManager.deleteAll()
        
        var weightData = WeightData()
        
        weightData.weightKilo = 100
        weightData.weightGramm = 0
        weightData.date = .now
        weightData.photoData = nil
        
        storageManager.save(weightData)
        
        weightData = WeightData()
        
        weightData.weightKilo = 90
        weightData.weightGramm = 0
        weightData.date = .now + 24 * 60 * 60
        weightData.photoData = nil
        
        storageManager.save(weightData)
    }

}
