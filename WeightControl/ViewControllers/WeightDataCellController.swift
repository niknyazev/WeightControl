//
//  WeightDataCellController.swift
//  WeightControl
//
//  Created by Николай on 17.03.2022.
//

import UIKit

class WeightDataCellController: UITableViewCell {

    // MARK: - Properties
 
    private lazy var dateLabel: UILabel = {
        let result = UILabel()
        return result
    }()
    
    private lazy var weightLabel: UILabel = {
        let result = UILabel()
        result.textColor = Colors.title
        return result
    }()
    
    private lazy var weightChangeLabel: UILabel = {
        let result = UILabel()
        result.font = .systemFont(ofSize: 12)
        return result
    }()
    
    private lazy var iconImage: UIImageView = {
        let result = UIImageView(image: UIImage(systemName: "person.circle"))
        return result
    }()
    
    public static let identifier = "weightData"
    
    // MARK: - Public methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configure(with weightDate: WeightData, weightChange: Double?) {
        
        dateLabel.text = weightDate.dateDescription
        weightLabel.text = weightDate.weightDescription
        iconImage.tintColor = weightDate.photoData == nil ? .systemGray3 : Colors.title

        if let weightChange = weightChange {
            let prefix = weightChange > 0 ? "+" : ""
            weightChangeLabel.text = prefix +  String(format: "%.2f", weightChange)
            weightChangeLabel.textColor = weightChange > 0 ? Colors.failure : Colors.success
            weightChangeLabel.isHidden = false
        } else {
            weightChangeLabel.isHidden = true
        }
    }
    
    // MARK: - Private methods
    
    private func setupElements() {
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(weightLabel)
        contentView.addSubview(weightChangeLabel)
        contentView.addSubview(iconImage)
        
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconImage.heightAnchor.constraint(equalToConstant: 35),
            iconImage.widthAnchor.constraint(equalToConstant: 35)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 12),
            dateLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            weightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        weightChangeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weightChangeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            weightChangeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
    }

}
