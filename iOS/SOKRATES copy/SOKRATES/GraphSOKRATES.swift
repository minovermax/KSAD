//
//  GraphSOKRATES.swift
//  SOKRATES
//
//  Created by 이성민 on 11/10/19.
//  Copyright © 2019 KSAD. All rights reserved.
//

import UIKit
import Charts

class GraphSOKRATES: UIViewController {
    
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBAction func resetButton(_ sender: Any) {
        
        let alertReset = UIAlertController(title: "Reset?", message: "Do you really want to reset your request data?", preferredStyle: .alert)
        alertReset.addAction(UIAlertAction(title: "Reset", style: .default, handler:  resetData))
        alertReset.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        
        present(alertReset, animated: true, completion: nil)
        
    }
    
    func resetData(action: UIAlertAction) {
        UserDefaults.init(suiteName: "group.com.ksad.sokrates")?.setValue(0, forKey: "inspiringCounter")
        UserDefaults.init(suiteName: "group.com.ksad.sokrates")?.setValue(0, forKey: "empoweringCounter")
        UserDefaults.init(suiteName: "group.com.ksad.sokrates")?.setValue(0, forKey: "motivatingCounter")
        
        updateChartData()
        updateChart()
        
        isDataReset = true
    }
    
    
    
    // pie chart stuff
    var inspiringDataEntry = PieChartDataEntry(value: 0)
    var empoweringDataEntry = PieChartDataEntry(value: 0)
    var motivatingDataEntry = PieChartDataEntry(value: 0)
    

    var numberOfCounterDataEntries = [PieChartDataEntry]()
    
    // animate conditions
    var isDataReset = false
    var isFirstLaunch = true


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateChart()
        updateChartData()
        
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = NumberFormatter.Style.percent
        
        
        pieChart.holeRadiusPercent = 0.3
        pieChart.drawEntryLabelsEnabled = false
        pieChart.transparentCircleRadiusPercent = 0.4
        pieChart.rotationEnabled = false
        pieChart.backgroundColor = UIColor(named: "backgroundColor")
        pieChart.usePercentValuesEnabled = true
        
        pieChart.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
        
        let sumOfValues = (UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "inspiringCounter") as! Double) + (UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "empoweringCounter") as! Double) + (UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "motivatingCounter") as! Double)
        
        if (sumOfValues != 0 && isFirstLaunch) {
            isFirstLaunch = false
        }
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        updateChart()
        updateChartData()
        
        let sumOfValues = (UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "inspiringCounter") as! Double) + (UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "empoweringCounter") as! Double) + (UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "motivatingCounter") as! Double)
        
        
        if ((isDataReset == true && sumOfValues != 0) || isFirstLaunch) {
            pieChart.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
            isDataReset = false
        }
        
        if (sumOfValues != 0 && isFirstLaunch) {
            isFirstLaunch = false
        }
        
    }
    

    
    func updateChartData() {
        
        let chartDataSet = PieChartDataSet(entries: numberOfCounterDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        
        let colors = [UIColor(named: "inspiringColor"), UIColor(named: "empoweringColor"), UIColor(named: "motivatingColor")]
        
        chartDataSet.colors = colors as! [NSUIColor]
        
        pieChart.data = chartData
    }
    
    func updateChart() {
        
        
        pieChart.chartDescription?.text = ""
        
        inspiringDataEntry.value = UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "inspiringCounter") as! Double
        inspiringDataEntry.label = "INSPIRATION"
        
        empoweringDataEntry.value = UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "empoweringCounter") as! Double
        empoweringDataEntry.label = "EMPOWERMENT"
        
        motivatingDataEntry.value = UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "motivatingCounter") as! Double
        motivatingDataEntry.label = "MOTIVATION"
        
        numberOfCounterDataEntries = [inspiringDataEntry, empoweringDataEntry, motivatingDataEntry]
        
        updateChartData()
        
    }
    
    // MARK: - Foramtter

}
