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
        chartView.drawBordersEnabled = true
        chartView.borderColor = .systemGray
        
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
    
    private lazy var circleProgressView: UIView = {
        let result = UIView()
        result.backgroundColor = .white
        return result
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
        label.text = "current"
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
        label.text = "start"
        label.textColor = .systemGray
        return label
    }()
    
    // MARK: - Progress label
    
    private lazy var progressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "progress"
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var progressLayer: UILabel = {
        let label = UILabel()
        label.text = "30"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .tintColor
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
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        addProgressCircle(flashcardsLearned: 0.3, color: .red)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Public methods
    
    func updateChart() {
        weightData = StorageManager.shared.realm.objects(WeightData.self).sorted(byKeyPath: "date")
        setChartData()
    }

    // MARK: - Private methods
    
    private func setupTopInformationViews() {
        
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
        
    }
    
    private func setupChartView() {
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: currentWeightStackView.bottomAnchor, constant: 10),
            lineChartView.heightAnchor.constraint(equalTo: lineChartView.widthAnchor, multiplier: 1),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
    }
    
    private func setupBottomInformationViews() {
        
        circleProgressView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            circleProgressView.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 30),
            circleProgressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleProgressView.heightAnchor.constraint(equalToConstant: 120),
            circleProgressView.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        circleProgressView.addSubview(progressLayer)
        circleProgressView.addSubview(progressTitleLabel)
        
        progressLayer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressLayer.topAnchor.constraint(equalTo: circleProgressView.topAnchor, constant: 55),
            progressLayer.centerXAnchor.constraint(equalTo: circleProgressView.centerXAnchor)
        ])
        
        progressTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressTitleLabel.topAnchor.constraint(equalTo: circleProgressView.topAnchor, constant: 30),
            progressTitleLabel.centerXAnchor.constraint(equalTo: circleProgressView.centerXAnchor)
        ])
        
    }
    
    private func setupElements() {
                
        view.addSubview(currentWeightStackView)
        view.addSubview(startWeight)
        view.addSubview(remainWeight)
        view.addSubview(lineChartView)
        view.addSubview(circleProgressView)
        view.addSubview(buttonAddWeightData)
        
        setupTopInformationViews()
        setupChartView()
        setupBottomInformationViews()

    }
    
    
    @IBAction func addWeightDataPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @objc private func addWeightData() {
        
    }
    
    private func addProgressCircle(flashcardsLearned: Float, color: UIColor) {
                  
        let center = circleProgressView.center
        let radius = 60.0
        
        let circle = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -(.pi / 2),
            endAngle: .pi * 1.5,
            clockwise: true
        )
        
        let track = CAShapeLayer()
        track.path = circle.cgPath
        track.fillColor = UIColor.clear.cgColor
        track.lineWidth = 12
        track.strokeColor = UIColor.systemGray5.cgColor
        
        view.layer.addSublayer(track)
        
        let fill = CAShapeLayer()
        fill.path = circle.cgPath
        fill.fillColor = UIColor.clear.cgColor
        fill.lineWidth = 12
        fill.strokeColor = color.cgColor
        fill.strokeStart = 0
        fill.strokeEnd = CGFloat(flashcardsLearned)
        fill.lineCap = .round
       
        view.layer.addSublayer(fill)
        
    }
    
    private func setChartData() {
        
        lineChartView.data = nil
        
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

