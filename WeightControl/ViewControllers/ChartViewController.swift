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
        leftAxis.drawAxisLineEnabled = false
        leftAxis.granularity = 10.0
        
        let xAsis = chartView.xAxis
        xAsis.labelPosition = .bottom
        xAsis.enabled = false
        xAsis.granularity = 2.0
        
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
    
    private lazy var currentWeightStackView: UIStackView = {
        let result = UIStackView()
        result.axis = .vertical
        result.alignment = .center
        return result
    }()
    
    private lazy var startWeight: UIStackView = {
        let result = UIStackView()
        result.axis = .vertical
        result.alignment = .center
        return result
    }()

    private lazy var remainWeight: UIStackView = {
        let result = UIStackView()
        result.axis = .vertical
        result.alignment = .center
        return result
    }()
    
    private lazy var currentWeightLabel: UILabel = {
        let label = UILabel()
        label.text = "weight"
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var currentWeightValueLabel: UILabel = {
        let label = UILabel()
        label.text = "80"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .tintColor
        return label
    }()
    
    private lazy var startWeightLabel: UILabel = {
        let label = UILabel()
        label.text = "index"
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var startWeightValueLabel: UILabel = {
        let label = UILabel()
        label.text = "75"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .tintColor
        return label
    }()

    private lazy var remainWeightLabel: UILabel = {
        let label = UILabel()
        label.text = "remain"
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var remainWeightValueLabel: UILabel = {
        let label = UILabel()
        label.text = "75"
        label.font = .systemFont(ofSize: 30)
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
        weightData = StorageManager.shared.realm.objects(WeightData.self).sorted(byKeyPath: "date")
        setChartData()
    }

    // MARK: - Private methods
    
    private func setupElements() {
                
        view.addSubview(currentWeightStackView)
        view.addSubview(startWeight)
        view.addSubview(remainWeight)
        view.addSubview(lineChartView)
        view.addSubview(buttonAddWeightData)
        
        startWeight.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            startWeight.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            startWeight.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            startWeight.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        startWeight.addArrangedSubview(startWeightLabel)
        startWeight.addArrangedSubview(startWeightValueLabel)
        
        currentWeightStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currentWeightStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            currentWeightStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWeightStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        currentWeightStackView.addArrangedSubview(currentWeightLabel)
        currentWeightStackView.addArrangedSubview(currentWeightValueLabel)
        
        remainWeight.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            remainWeight.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            remainWeight.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            remainWeight.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        remainWeight.addArrangedSubview(remainWeightLabel)
        remainWeight.addArrangedSubview(remainWeightValueLabel)
                
        lineChartView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: currentWeightStackView.bottomAnchor, constant: 20),
            lineChartView.heightAnchor.constraint(equalTo: lineChartView.widthAnchor, multiplier: 1),
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
        
        lineChartView.data = nil
        
        var weightValues: [ChartDataEntry] = []
        var maxValue: Float = 0
        var minValue: Float = 500
        for (index, value) in weightData.enumerated() {
            weightValues.append(ChartDataEntry(x: Double(index), y: Double(value.weight)))
            maxValue = max(maxValue, value.weight)
            minValue = min(minValue, value.weight)
        }
        
        // TODO: argly code
        lineChartView.leftAxis.axisMaximum = Double((Int(maxValue / 10) * 10) + 10)
        lineChartView.leftAxis.axisMinimum = Double((Int(minValue / 10) * 10) - 10)
        
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

