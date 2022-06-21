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
        sut = UserDefaultsManager.shared
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFetchDefaultUserData() throws {
        
        removeData()
        
        let userData = sut.fetchUserData()
            
        XCTAssertEqual(userData.age, 18)
        XCTAssertEqual(userData.height, 180)
        XCTAssertEqual(userData.sex, .male)
        XCTAssertEqual(userData.weightGoal, 80)
    }
    
    func testSaveUserData() throws {
        
        removeData()
        
        let userDataForSaving = UserData(
            age: 20,
            height: 175,
            weightGoal: 50,
            sex: .female
        )
        
        sut.saveUserData(userData: userDataForSaving)
        
        let userData = sut.fetchUserData()
        
        XCTAssertEqual(userData.age, 20)
        XCTAssertEqual(userData.height, 175)
        XCTAssertEqual(userData.sex, .female)
        XCTAssertEqual(userData.weightGoal, 50)
    }
    
    private func removeData() {
        UserDefaults.standard.set(nil, forKey: "userData")
    }
    
}
