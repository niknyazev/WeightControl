//
//  WeightHistoryViewModel.swift
//  WeightControl
//
//  Created by Николай on 09.04.2022.
//

import Foundation

protocol WeightHistoryViewModelProtocol {
    var weightDatas: [WeightData] { get }
}

class WeightHistoryViewModel: WeightHistoryViewModelProtocol {
    var weightDatas: [WeightData] = []
}
