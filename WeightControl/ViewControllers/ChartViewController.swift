//
//  ChartViewController.swift
//  WeightControl
//
//  Created by Николай on 24.02.2022.
//

import UIKit
import Charts
import RealmSwift

class ChartViewController: UIViewController {
    
    // MARK: - Properties

    private var weightData: Results<WeightData>!
    
    private lazy var lineChartView: LineChartView = {
        let frame = CGRect()
        let chartView = LineChartView(frame: frame)
        chartView.backgroundColor = .white
        return chartView
    }()
    
    private lazy var buttonAddWeightData: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("Add weight", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(addWeightData), for: .touchUpInside)
        return button
        
    }()
    
    private lazy var currentWeightLabel: UILabel = {
        let label = UILabel()
        label.text = "Current weight: 80"
        label.textColor = .black
        return label
    }()
    
    private lazy var weightRemaining: UILabel = {
        let label = UILabel()
        label.text = "Remaining: 10"
        label.textColor = .black
        return label
    }()
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        updateChart()
    }
    
    // MARK: - Public methods
    
    func updateChart() {
        weightData = StorageManager.shared.realm.objects(WeightData.self)
        setChartData()
    }

    // MARK: - Private methods
    
    func setupElements() {
        
        view.addSubview(currentWeightLabel)
        view.addSubview(weightRemaining)
        view.addSubview(lineChartView)
        view.addSubview(buttonAddWeightData)
        
        currentWeightLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currentWeightLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            currentWeightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            currentWeightLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -300)
        ])
        
        weightRemaining.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            weightRemaining.topAnchor.constraint(equalTo: currentWeightLabel.bottomAnchor, constant: 20),
            weightRemaining.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weightRemaining.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -300)
        ])
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: weightRemaining.bottomAnchor, constant: 20),
            lineChartView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        buttonAddWeightData.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonAddWeightData.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 30),
            buttonAddWeightData.heightAnchor.constraint(equalToConstant: 50),
            buttonAddWeightData.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            buttonAddWeightData.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
    }
    
    @objc private func addWeightData() {
        
    }
    
    private func setChartData() {
        
        var weightValues: [ChartDataEntry] = []
        for (index, value) in weightData.enumerated() {
            weightValues.append(ChartDataEntry(x: Double(index), y: Double(value.weight)))
        }
        
        let dataSet = LineChartDataSet(entries: weightValues, label: "Weight data")
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
    }
    

}

extension ChartViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }

}

