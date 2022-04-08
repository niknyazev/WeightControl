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
    private var progress: Int?
    
    
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
        
    private lazy var currentWeightStackView: InformationStackView = {
        let result = InformationStackView()
        result.titleLabel.text = "current"
        return result
    }()
    
    private lazy var startWeightStackView: InformationStackView = {
        let result = InformationStackView()
        result.titleLabel.text = "start"
        return result
    }()

    private lazy var remainWeightStackView: InformationStackView = {
        let result = InformationStackView()
        result.titleLabel.text = "remain"
        return result
    }()
    
    private lazy var progressStackView: InformationStackView = {
        let result = InformationStackView()
        result.titleLabel.text = "progress"
        return result
    }()
            
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        updateWeightData()
    }
    
    override func viewDidLayoutSubviews() {
        addProgressCircle(flashcardsLearned: Float(progress ?? 0) / 100, color: Colors.accent)
    }

    // MARK: - Private methods
    
    private func fetchWeightData() {
        weightData = StorageManager.shared.realm.objects(WeightData.self).sorted(byKeyPath: "date")
    }
    
    private func fillElementValues() {
        
        let currentWeightDifference = (weightData.last?.weightKilo ?? 0) - userData.weightGoal
        let startWeightDifference = (weightData.first?.weightKilo ?? 0) - userData.weightGoal
        progress = 100 - (currentWeightDifference / startWeightDifference) * 100

        currentWeightStackView.valueLabel.text = String(weightData.last?.weightKilo ?? 0)
        startWeightStackView.valueLabel.text = String(weightData.first?.weightKilo ?? 0)
        remainWeightStackView.valueLabel.text = String(currentWeightDifference < 0 ? 0 : currentWeightDifference)
        progressStackView.valueLabel.text =  currentWeightDifference < 0 ? "100" : String(progress ?? 0)
        
    }
    
    private func fetchUserData() {
        userData = UserDefaultsManager.shared.fetchUserData()
    }
    
    private func setupTopInformationViews() {
        
        let saveArea = view.safeAreaLayoutGuide
        
        startWeightStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            startWeightStackView.topAnchor.constraint(equalTo: saveArea.topAnchor, constant: 20),
            startWeightStackView.leadingAnchor.constraint(equalTo: saveArea.leadingAnchor, constant: 60),
            startWeightStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
                
        currentWeightStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currentWeightStackView.topAnchor.constraint(equalTo: saveArea.topAnchor, constant: 20),
            currentWeightStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWeightStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
                
        remainWeightStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            remainWeightStackView.topAnchor.constraint(equalTo: saveArea.topAnchor, constant: 20),
            remainWeightStackView.trailingAnchor.constraint(equalTo: saveArea.trailingAnchor, constant: -60),
            remainWeightStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
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
        
        circleProgressView.addSubview(progressStackView)

        progressStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressStackView.topAnchor.constraint(equalTo: circleProgressView.topAnchor, constant: 32),
            progressStackView.centerXAnchor.constraint(equalTo: circleProgressView.centerXAnchor)
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
        view.addSubview(startWeightStackView)
        view.addSubview(remainWeightStackView)
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

extension ChartViewController: WeightDataUpdaterDelegate {
    
    func updateWeightData() {
        fetchUserData()
        fetchWeightData()
        fillElementValues()
        setChartData()
    }
}

class InformationStackView: UIStackView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.textColor = .systemGray
        return label
    }()
        
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 30)
        label.textColor = Colors.title
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addElements()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        alignment = .center
    }
    
    private func addElements() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(valueLabel)
    }
}

