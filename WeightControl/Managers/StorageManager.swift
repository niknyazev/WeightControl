//
//  StorageManager.swift
//  WeightControl
//
//  Created by Николай on 01.03.2022.
//

import RealmSwift

class StorageManager {
    
    // MARK: - Properties
   
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    // MARK: - Public methods
    
    func save(_ weightData: WeightData) {
        write {
            realm.add(weightData)
        }
    }
    
    func delete(_ weightData: WeightData) {
        write {
            realm.delete(weightData)
        }
    }
    
    func edit(_ weightData: WeightData, date: Date, weightKilo: Int, weightGramm: Int, photoData: Data?) {
        write {
            weightData.date = date
            weightData.weightKilo = weightKilo
            weightData.weightGramm = weightGramm
            weightData.photoData = photoData
        }
    }
    
    // MARK: - Private methods
        
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch let error {
            print(error)
        }
    }
}
