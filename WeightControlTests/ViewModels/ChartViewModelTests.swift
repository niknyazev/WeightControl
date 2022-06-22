//
//  ChartViewModelTests.swift
//  WeightControlTests
//
//  Created by Николай on 22.06.2022.
//

import XCTest
@testable import WeightControl

class ChartViewModelTests: XCTestCase {

    private var sut: ChartViewModelProtocol!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests
    
    func testChartValues() throws {
        
        saveUserData()
        saveWeightData()
        
        sut = ChartViewModel()
        
        XCTAssertEqual(sut.startWeight, "100")
        XCTAssertEqual(sut.currentWeight, "90")
        XCTAssertEqual(sut.remainWeight, "10")
        XCTAssertEqual(sut.progress, "50")
        XCTAssertEqual(sut.progressValue, 50)
        XCTAssertEqual(sut.weightValues.count, 2)
    }

    // MARK: - Private methods
    
    private func saveUserData() {
        
        let userDataForSaving = UserData(
            age: 20,
            height: 175,
            weightGoal: 80,
            sex: .female
        )
        
        UserDefaultsManager.shared.saveUserData(userData: userDataForSaving)
    }
    
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
