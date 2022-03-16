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
       
        let chartView = LineChartView()
        chartView.backgroundColor = .white
        chartView.legend.enabled = false
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.axisMaximum = 80
        leftAxis.axisMinimum = 0
        leftAxis.drawAxisLineEnabled = false
        
        let xAsis = chartView.xAxis
        xAsis.labelPosition = .bottom
        xAsis.enabled = true
        xAsis.granularity = 2
        
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
        label.text = "Current weight:"
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var currentWeightValueLabel: UILabel = {
        let label = UILabel()
        label.text = "80"
        label.textColor = .tintColor
        return label
    }()
    
    private lazy var weightRemainingLabel: UILabel = {
        let label = UILabel()
        label.text = "Remaining:"
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var weightRemainingValueLabel: UILabel = {
        let label = UILabel()
        label.text = "75"
        label.textColor = .tintColor
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
    
    private func setupElements() {
        
        view.addSubview(currentWeightLabel)
        view.addSubview(currentWeightValueLabel)
        view.addSubview(weightRemainingLabel)
        view.addSubview(weightRemainingValueLabel)
        view.addSubview(lineChartView)
        view.addSubview(buttonAddWeightData)
        
        currentWeightLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currentWeightLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            currentWeightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            currentWeightLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -300)
        ])
        
        currentWeightValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentWeightValueLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            currentWeightValueLabel.leadingAnchor.constraint(equalTo: currentWeightLabel.trailingAnchor, constant: 5),
            currentWeightValueLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -300)
        ])
        
        weightRemainingLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            weightRemainingLabel.topAnchor.constraint(equalTo: currentWeightLabel.bottomAnchor, constant: 10),
            weightRemainingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weightRemainingLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -300)
        ])
        
        weightRemainingValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weightRemainingValueLabel.topAnchor.constraint(equalTo: currentWeightLabel.bottomAnchor, constant: 10),
            weightRemainingValueLabel.leadingAnchor.constraint(equalTo: weightRemainingLabel.trailingAnchor, constant: 5),
            weightRemainingValueLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -300)
        ])
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: weightRemainingLabel.bottomAnchor, constant: 20),
            lineChartView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        buttonAddWeightData.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonAddWeightData.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 30),
            buttonAddWeightData.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonAddWeightData.heightAnchor.constraint(equalToConstant: 50),
            buttonAddWeightData.widthAnchor.constraint(equalToConstant: 250)
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
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.drawValuesEnabled = false
        dataSet.setColor(.red)
        
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
    }
    

}

extension ChartViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }

}

