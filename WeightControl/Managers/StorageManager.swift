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
    
    private let realm = try! Realm()
    
    private init() {}
    
    // MARK: - Public methods
    
    func getSortedWeightData(ascending: Bool = true) -> Results<WeightData> {
        realm.objects(WeightData.self).sorted(byKeyPath: "date", ascending: ascending)
    }
        
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
    
    func deleteAll() {
        write {
            realm.deleteAll()
        }
    }
    
    func edit(_ weightData: WeightData, date: Date, weightKilo: Int, weightGramm: Int, photoData: Data?, note: String) {
        write {
            weightData.date = date
            weightData.weightKilo = weightKilo
            weightData.weightGramm = weightGramm
            weightData.photoData = photoData
            weightData.note = note
        }
    }
    
    // Function for editing weight data in compact mode (without choosing photo)
    func edit(_ weightData: WeightData, date: Date, weightKilo: Int, weightGramm: Int) {
        write {
            weightData.date = date
            weightData.weightKilo = weightKilo
            weightData.weightGramm = weightGramm
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
