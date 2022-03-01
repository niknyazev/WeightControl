//
//  ViewController.swift
//  WeightControl
//
//  Created by Николай on 24.02.2022.
//

import UIKit
import Charts

class ViewController: UIViewController {

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
    
    let points = [
        ChartDataEntry(x: 10, y: 20),
        ChartDataEntry(x: 20, y: 10),
        ChartDataEntry(x: 30, y: 30),
        ChartDataEntry(x: 40, y: 40),
        ChartDataEntry(x: 50, y: 10)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lineChartView)
        lineChartView.center = view.center
        setChartData()
    }

    private func setChartData() {
        let dataSet = LineChartDataSet(entries: points, label: "Weight data")
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
    }
    

}

extension ViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }

}

