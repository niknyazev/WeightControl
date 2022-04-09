//
//  SettingsViewModel.swift
//  WeightControl
//
//  Created by Николай on 09.04.2022.
//

import Foundation

protocol SettingsViewModelProtocol {
    var age: Int { get }
    var height: Int { get }
    var weightGoal: Int { get }
    var sex: UserData.Sex { get }
}

class SettingsViewModel: SettingsViewModelProtocol {
    var age: Int = 0
    var height: Int = 0
    var weightGoal: Int = 0
    var sex: UserData.Sex = .male
}
