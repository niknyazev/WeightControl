//
//  WeightDataCellViewModel.swift
//  WeightControl
//
//  Created by Николай on 09.04.2022.
//

import Foundation

protocol WeightDataCellViewModelProtocol {
    var date: Date { get }
    var weight: Int { get }
    var hasPicture: Bool { get }
    var weightChange: Double { get }
}

class WeightDataCellViewModel: WeightDataCellViewModelProtocol {
    var date: Date = .now
    var weight: Int = 0
    var hasPicture: Bool = false
    var weightChange: Double = 0
}
