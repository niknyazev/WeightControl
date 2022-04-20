//
//  WeightDataDetailsViewController.swift
//  WeightControl
//
//  Created by Николай on 22.03.2022.
//

import UIKit

class WeightDataDetailsViewController: UITableViewController {
    
    // MARK: - Properties
    
    var weightDataViewModel: WeightDataDetailsViewModelProtocol!
    var delegate: WeightDataUpdaterDelegate!
        
    private lazy var datePicker: UIDatePicker = {
        let result = UIDatePicker()
        return result
    }()
    
    private lazy var weightPicker: UIPickerView = {
        let result = UIPickerView()
        return result
    }()
    
    private lazy var bodyImage: UIImageView = {
        let result = UIImageView(image: UIImage(systemName: "camera"))
        result.contentMode = .scaleAspectFit
        result.tintColor = .systemGray3
        result.layer.cornerRadius = 15
        result.layer.masksToBounds = true
        return result
    }()
    
    private lazy var descriptionField: UITextView = {
        let result = UITextView()
        result.delegate = self
        result.font = UIFont.systemFont(ofSize: 17)
        return result
    }()
    
    private let placeHolderColor = UIColor.systemGray4
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 60
        case 1:
            return 150
        case 2:
            return 240
        case 3:
            return 130
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            setupDateCell(cell)
        case 1:
            setupWeightCell(cell)
        case 2:
            setupPhotoCell(cell)
        case 3:
            setupDescriptionCell(cell)
        default:
            fatalError()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != 2 {
            return
        }
            
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
    
    // MARK: - Handler methods
    
    @objc func savePressed() {
        
        let imageData = bodyImage.contentMode == .scaleAspectFit
            ? nil
            : bodyImage.image?.pngData()
        
        weightDataViewModel.saveData(
            date: datePicker.date,
            weightKilo: weightPicker.selectedRow(inComponent: 0),
            weightGramm: weightPicker.selectedRow(inComponent: 1),
            photoData: imageData
        )
        
        delegate.updateWeightData()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    
    
    private func setupDateCell(_ cell: UITableViewCell) {
        
        cell.contentView.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
    }
    
    private func setupWeightCell(_ cell: UITableViewCell) {
        
        cell.contentView.addSubview(weightPicker)
        
        weightPicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weightPicker.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
            weightPicker.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            weightPicker.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0),
            weightPicker.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupPhotoCell(_ cell: UITableViewCell) {
        
        cell.contentView.addSubview(bodyImage)
        
        bodyImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bodyImage.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            bodyImage.widthAnchor.constraint(equalTo: bodyImage.heightAnchor, multiplier: 1),
            bodyImage.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            bodyImage.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupDescriptionCell(_ cell: UITableViewCell) {
        
        cell.contentView.addSubview(descriptionField)
        
        descriptionField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
            descriptionField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            descriptionField.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            descriptionField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupNavigationBar() {
       
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = Colors.barBackground
        
        if let navigationController = navigationController {
            navigationController.navigationBar.prefersLargeTitles = false
            navigationController.navigationBar.compactAppearance = appearance
            navigationController.navigationBar.compactScrollEdgeAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
            navigationController.navigationBar.tintColor = .white
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(savePressed)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelPressed)
        )
    }
    
    private func setupElements() {
        
        setupNavigationBar()
        
        tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        
        datePicker.locale = Locale(identifier: "ru-RU")
        
        weightPicker.delegate = self
        weightPicker.dataSource = self
        
        datePicker.date = weightDataViewModel.date
        descriptionField.text = weightDataViewModel.note
        setupDescriptionField()
        setWeightPicker(
            kilo: weightDataViewModel.weightKilo,
            gram: weightDataViewModel.weightGramm
        )
        setupImage(with: weightDataViewModel.photoData)
    }
    
    private func setupImage(with data: Data?) {
        if let photoData = data {
            bodyImage.image = UIImage(data: photoData)
            bodyImage.contentMode = .scaleToFill
        } else {
            bodyImage.contentMode = .scaleAspectFit
        }
    }
    
    func setupDescriptionField() {
        if weightDataViewModel.note.isEmpty {
            descriptionField.text = "Description"
            descriptionField.textColor = placeHolderColor
        } else {
            descriptionField.textColor = .black
        }
    }
    
    private func setWeightPicker(kilo: Int, gram: Int) {
        weightPicker.selectRow(kilo, inComponent: 0, animated: false)
        weightPicker.selectRow(gram, inComponent: 1, animated: false)
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

extension WeightDataDetailsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeHolderColor {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.textColor == placeHolderColor {
            textView.text = nil
            textView.textColor = .black
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
