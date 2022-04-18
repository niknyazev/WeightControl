//
//  SettingsCellViewModel.swift
//  WeightControl
//
//  Created by Николай on 18.04.2022.
//

import Foundation

protocol SettingsCellViewModelProtocol {
    
    var values: [String] { get }
    var value: String { get set }
    var title: String { get }
    var isEditable: Bool { get }
    var titlePicker: String { get }
    
    func changeValue(with index: Int)
}

class SettingsCellViewModel: SettingsCellViewModelProtocol {
    
    let values: [String]
    var value: String
    let title: String
    let isEditable: Bool
    var titlePicker: String {
        "Choose \(title)"
    }
    
    init(values: [String], value: String, title: String, isEditable: Bool) {
        self.values = values
        self.value = value
        self.title = title
        self.isEditable = isEditable
    }
    
    func changeValue(with index: Int) {
        value = values[index]
    }
}
