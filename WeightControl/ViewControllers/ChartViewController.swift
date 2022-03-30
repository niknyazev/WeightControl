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
    private var userData: UserData!
    
    private lazy var lineChartView: LineChartView = {
       
        let chartView = LineChartView()
        chartView.legend.enabled = false
        chartView.drawBordersEnabled = true
        chartView.borderColor = Colors.chartBorder
        chartView.borderLineWidth = 2
        chartView.gridBackgroundColor = Colors.chartBackground
        chartView.drawGridBackgroundEnabled = true
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.drawAxisLineEnabled = false
        leftAxis.granularity = 10.0
        
        let xAsis = chartView.xAxis
        xAsis.labelPosition = .bottom
        xAsis.enabled = true
        xAsis.granularity = 2.0
        
        return chartView
    }()
    
    private lazy var circleProgressView: UIView = {
        let result = UIView()
        return result
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
        label.textColor = Colors.title
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
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.text = "30"
        label.font = .systemFont(ofSize: 30)
        label.textColor = Colors.title
        return label
    }()
    
    private lazy var startWeightValueLabel: UILabel = {
        let label = UILabel()
        label.text = "75"
        label.font = .systemFont(ofSize: 30)
        label.textColor = Colors.title
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
        label.textColor = Colors.title
        return label
    }()
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        updateWeightData()
    }
    
    override func viewDidLayoutSubviews() {
        addProgressCircle(flashcardsLearned: 0.3, color: Colors.accent)
    }

    // MARK: - Private methods
    
    private func fetchWeightData() {
        weightData = StorageManager.shared.realm.objects(WeightData.self).sorted(byKeyPath: "date")
    }
    
    private func fillElementValues() {
        
        let remainWeight = (weightData.last?.weightKilo ?? 0) - userData.weightGoal

        currentWeightValueLabel.text = String(weightData.last?.weightKilo ?? 0)
        startWeightValueLabel.text = String(weightData.first?.weightKilo ?? 0)
        remainWeightValueLabel.text = String(remainWeight < 0 ? 0 : remainWeight)
    }
    
    private func fetchUserData() {
        userData = UserDefaultsManager.shared.fetchUserData()
    }
    
    private func setupTopInformationViews() {
        
        let saveArea = view.safeAreaLayoutGuide
        
        startWeight.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            startWeight.topAnchor.constraint(equalTo: saveArea.topAnchor, constant: 20),
            startWeight.leadingAnchor.constraint(equalTo: saveArea.leadingAnchor, constant: 60),
            startWeight.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        startWeight.addArrangedSubview(startWeightLabel)
        startWeight.addArrangedSubview(startWeightValueLabel)
        
        currentWeightStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currentWeightStackView.topAnchor.constraint(equalTo: saveArea.topAnchor, constant: 20),
            currentWeightStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWeightStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        currentWeightStackView.addArrangedSubview(currentWeightLabel)
        currentWeightStackView.addArrangedSubview(currentWeightValueLabel)
        
        remainWeight.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            remainWeight.topAnchor.constraint(equalTo: saveArea.topAnchor, constant: 20),
            remainWeight.trailingAnchor.constraint(equalTo: saveArea.trailingAnchor, constant: -60),
            remainWeight.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        remainWeight.addArrangedSubview(remainWeightLabel)
        remainWeight.addArrangedSubview(remainWeightValueLabel)
        
    }
    
    private func setupChartView() {
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: currentWeightStackView.bottomAnchor, constant: 10),
            lineChartView.bottomAnchor.constraint(equalTo: circleProgressView.topAnchor, constant: -25),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
    }
    
    private func setupBottomInformationViews() {
                        
        circleProgressView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            circleProgressView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            circleProgressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleProgressView.heightAnchor.constraint(equalToConstant: 115),
            circleProgressView.widthAnchor.constraint(equalToConstant: 115)
        ])
        
        circleProgressView.addSubview(progressLabel)
        circleProgressView.addSubview(progressTitleLabel)

        progressTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressTitleLabel.topAnchor.constraint(equalTo: circleProgressView.topAnchor, constant: 32),
            progressTitleLabel.centerXAnchor.constraint(equalTo: circleProgressView.centerXAnchor)
        ])
        
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressLabel.topAnchor.constraint(equalTo: progressTitleLabel.bottomAnchor, constant: 5),
            progressLabel.centerXAnchor.constraint(equalTo: circleProgressView.centerXAnchor)
        ])
        
    }
    
    private func setupElements() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addWeightData)
        )
        
        view.backgroundColor = .systemBackground
        title = "Weight control"
                
        view.addSubview(currentWeightStackView)
        view.addSubview(startWeight)
        view.addSubview(remainWeight)
        view.addSubview(lineChartView)
        view.addSubview(circleProgressView)
        
        setupTopInformationViews()
        setupChartView()
        setupBottomInformationViews()

    }
        
    @objc private func addWeightData() {
        
        let weightDetails = WeightDataDetailsViewController()
        
        weightDetails.delegate = self
        weightDetails.lastWeightData = weightData.last
        
        present(
            UINavigationController(rootViewController: weightDetails),
            animated: true,
            completion: nil
        )
    }
    
    private func addProgressCircle(flashcardsLearned: Float, color: UIColor) {
                  
        let center = circleProgressView.center
        let radius = circleProgressView.bounds.width / 2
        
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
        dataSet.setColor(Colors.accent)
        dataSet.lineWidth = 2
        
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
    }
    

}

extension ChartViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }

}

extension ChartViewController: WeightDataUpdaterDelegate {
    
    func updateWeightData() {
        fetchUserData()
        fetchWeightData()
        fillElementValues()
        setChartData()
    }
}

