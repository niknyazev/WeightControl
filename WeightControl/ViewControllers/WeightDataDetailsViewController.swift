//
//  WeightDataDetailsViewController.swift
//  WeightControl
//
//  Created by Николай on 22.03.2022.
//

import UIKit

class WeightDataDetailsViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var weightPicker: UIPickerView!
    
    var weightData: WeightData?
    
    private let storageManager = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    // MARK: - IBAction methods
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if let weightData = weightData {
            storageManager.edit(
                weightData,
                date: datePicker.date,
                weightKilo: weightPicker.selectedRow(inComponent: 0),
                weightGramm: weightPicker.selectedRow(inComponent: 1)            )
        } else {
            let currentWeightData = WeightData()
            
            currentWeightData.weightKilo = weightPicker.selectedRow(inComponent: 0)
            currentWeightData.weightGramm = weightPicker.selectedRow(inComponent: 1)
            currentWeightData.date = datePicker.date
            
            storageManager.save(currentWeightData)
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupElements() {
        
        weightPicker.delegate = self
        weightPicker.dataSource = self
        
        guard let weightData = weightData else {
            return
        }
        
        datePicker.date = weightData.date
        weightPicker.selectRow(weightData.weightKilo, inComponent: 0, animated: false)
        weightPicker.selectRow(weightData.weightGramm, inComponent: 1, animated: false)
        
    }
    
}

// MARK: - UIPickerViewDelegate

extension WeightDataDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        String(row)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 200
        } else {
            return 10
        }
    }
}
