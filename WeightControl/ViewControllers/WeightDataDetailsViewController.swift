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
    @IBOutlet weak var bodyImage: UIImageView!
    
    var weightData: WeightData?
    var lastWeightData: WeightData?
    var delegate: WeightDataUpdaterDelegate!
    
    private let storageManager = StorageManager.shared
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            let alertController = UIAlertController(
                title: nil,
                message: nil,
                preferredStyle: .actionSheet
            )
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(camera)
            alertController.addAction(photo)
            alertController.addAction(cancel)
            
            present(alertController, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        bodyImage.layer.cornerRadius = 10
    }
    
    // MARK: - IBAction methods
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if let weightData = weightData {
            storageManager.edit(
                weightData,
                date: datePicker.date,
                weightKilo: weightPicker.selectedRow(inComponent: 0),
                weightGramm: weightPicker.selectedRow(inComponent: 1),
                photoData: bodyImage.image?.pngData()
            )
        } else {
            let currentWeightData = WeightData()
            
            currentWeightData.weightKilo = weightPicker.selectedRow(inComponent: 0)
            currentWeightData.weightGramm = weightPicker.selectedRow(inComponent: 1)
            currentWeightData.date = datePicker.date
            currentWeightData.photoData = bodyImage.image?.pngData()
            
            storageManager.save(currentWeightData)
        }
        
        delegate.updateWeightData()
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupElements() {
        
        weightPicker.delegate = self
        weightPicker.dataSource = self
        
        guard let weightData = weightData else {
            if let lastWeightData = lastWeightData {
                weightPicker.selectRow(lastWeightData.weightKilo, inComponent: 0, animated: false)
                weightPicker.selectRow(lastWeightData.weightGramm, inComponent: 1, animated: false)
            } else {
                weightPicker.selectRow(50, inComponent: 0, animated: false)
            }
            return
        }
        
        datePicker.date = weightData.date
        weightPicker.selectRow(weightData.weightKilo, inComponent: 0, animated: false)
        weightPicker.selectRow(weightData.weightGramm, inComponent: 1, animated: false)
        
        if let photoData = weightData.photoData {
            bodyImage.image = UIImage(data: photoData)
            bodyImage.contentMode = .scaleToFill
        }
        
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

extension WeightDataDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        bodyImage.image = info[.editedImage] as? UIImage
        bodyImage.contentMode = .scaleToFill
        bodyImage.clipsToBounds = true
        dismiss(animated: true)
    }
}
