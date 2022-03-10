//
//  UserDefaultsManager.swift
//  WeightControl
//
//  Created by Николай on 06.03.2022.
//

import Foundation

struct UserData: Codable {
    
    enum Sex: String, Codable {
        case male
        case female
    }
    
    let age: Int
    let height: Int
    let weightGoal: Int
    let sex: Sex
}

class UserDefaultsManager {
    
    // MARK: - Properties
    
    static let shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults.standard
    private let key = "userData"
    
    private init() {}
    
    // MARK: - Public methods
    
    func saveUserData(userData: UserData) {
        guard let data = try? JSONEncoder().encode(userData) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func fetchUserData() -> UserData? {
        
        guard let data = userDefaults.data(forKey: key) else { return nil }
        guard let result = try? JSONDecoder().decode(UserData.self, from: data) else { return nil }
        return result
    
    }
}
