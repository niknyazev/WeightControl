//
//  UserDefaultsManager.swift
//  WeightControl
//
//  Created by Николай on 06.03.2022.
//

import Foundation

struct UserData {
    let age: Int
    let height: Int
    let weightGoal: Int
}

class UserDefaultsManager {
    
    // MARK: - Properties
    
    static let shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults.standard
    private let sortingKey = "userData"
    
    private init() {}
    
    // MARK: - Public methods
    
    func saveSortingType(sortingType: Int) {
        userDefaults.set(sortingType, forKey: sortingKey)
    }
    
    func fetchSortingType() -> Int {
        userDefaults.integer(forKey: sortingKey)
    }
    
}
