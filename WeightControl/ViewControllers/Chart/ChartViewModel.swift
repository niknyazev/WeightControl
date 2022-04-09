//
//  ChartViewModel.swift
//  WeightControl
//
//  Created by Николай on 09.04.2022.
//

import Foundation

protocol ChartViewModelProtocol {
    var startWeight: Double { get }
    var currentWeight: Double { get }
    var remainWeight: Double { get }
    var progress: Int { get }
}

class ChartViewModel: ChartViewModelProtocol {
    var startWeight: Double = 0
    var currentWeight: Double = 0
    var remainWeight: Double = 0
    var progress: Int = 0
}
