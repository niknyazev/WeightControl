//
//  UserDefaultsManagerTests.swift
//  UserDefaultsManagerTests
//
//  Created by Николай on 10.06.2022.
//

import XCTest
@testable import WeightControl

class UserDefaultsManagerTests: XCTestCase {
    
    private var sut: UserDefaultsManager!

    override func setUp() {
        
        super.setUp()
        
        UserDefaults.standard.set(nil, forKey: "userData")
        sut = UserDefaultsManager.shared
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFetchDefaultUserData() throws {
        
        let userData = sut.fetchUserData()
        
        let allValuesCorrect =
            userData.age == 18 &&
            userData.height == 180 &&
            userData.sex == .male &&
            userData.weightGoal == 80
        
        XCTAssertTrue(allValuesCorrect, "Default UserDefaults values are not correct")
    }
    
    func testSaveUserData() throws {
        
        let userDataForSaving = UserData(
            age: 20,
            height: 175,
            weightGoal: 50,
            sex: .female
        )
        
        sut.saveUserData(userData: userDataForSaving)
        
        let userData = sut.fetchUserData()
        
        let allValuesCorrect =
            userData.age == 20 &&
            userData.height == 175 &&
            userData.sex == .female &&
            userData.weightGoal == 50
        
        XCTAssertTrue(allValuesCorrect, "UserDefaults values after saving are not correct")
    }
}
