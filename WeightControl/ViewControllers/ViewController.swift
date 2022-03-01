//
//  ViewController.swift
//  WeightControl
//
//  Created by Николай on 24.02.2022.
//

import UIKit
import Charts

class ViewController: UIViewController {

    var weightData: [WeightData] = []
    
    lazy var lineChartView: LineChartView = {
        let frame = CGRect(
            x: 0,
            y: 400,
            width: view.frame.width,
            height: view.frame.height - 400
        )
        let chartView = LineChartView(frame: frame)
        chartView.backgroundColor = .blue
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightData = StorageManager.shared.fetchData()
        view.addSubview(lineChartView)
        lineChartView.center = view.center
        setChartData()
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

extension ViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }

}

