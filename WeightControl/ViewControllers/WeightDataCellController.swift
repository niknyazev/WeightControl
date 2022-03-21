//
//  WeightDataCellController.swift
//  WeightControl
//
//  Created by Николай on 17.03.2022.
//

import UIKit

class WeightDataCellController: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightChangeLabel: UILabel!
    
    // MARK: - Public methods
    
    func configure(with weightDate: WeightData, weightChange: Float?) {
        
        dateLabel.text = weightDate.dateDescription
        weightLabel.text = weightDate.weightDescription
        
        if let weightChange = weightChange {
            weightChangeLabel.text = String(weightChange)
            weightChangeLabel.textColor = weightChange > 0 ? .red : .green
            weightChangeLabel.isHidden = false
        } else {
            weightChangeLabel.isHidden = true
        }
    }

}
