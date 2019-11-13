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
        
        let alertReset = UIAlertController(title: "Reset?", message: "Are you sure you want to reset your request data?", preferredStyle: .alert)
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
        
        // instanciating stuff
        let chartDataSet = PieChartDataSet(entries: numberOfCounterDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        
        // value format stuff
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        
        chartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        chartData.setValueFont(UIFont(name: "Futura-Medium", size: 15)!)
        
        // legend stuff
        pieChart.legend.font = UIFont(name: "Futura-Bold", size: 11.5)!
        pieChart.legend.orientation = .vertical
        
        // color stuff
        let colors = [UIColor(named: "inspiringColor"), UIColor(named: "motivatingColor"), UIColor(named: "empoweringColor")]
        
        chartDataSet.colors = colors as! [NSUIColor]
        
        // center stuff
        let inspiringValue = UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "inspiringCounter") as! Double
        
        let motivatingValue = UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "motivatingCounter") as! Double
        
        let empoweringValue = UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "empoweringCounter") as! Double
        
        if ((inspiringValue >= motivatingValue) && (inspiringValue > empoweringValue) || (inspiringValue > motivatingValue) && (inspiringValue >= empoweringValue)) {
            pieChart.chartDescription?.text = "You have seeked 🌟 the most."
        } else if ((motivatingValue >= inspiringValue) && (motivatingValue > empoweringValue) || (motivatingValue > inspiringValue) && (motivatingValue >= empoweringValue)) {
            pieChart.chartDescription?.text = "You have seeked 🔥 the most."
        } else if ((empoweringValue >= inspiringValue) && (empoweringValue > motivatingValue) || (empoweringValue > inspiringValue) && (empoweringValue >= motivatingValue)) {
            pieChart.chartDescription?.text = "You have seeked 💪🏻 the most."
        } else {
            pieChart.chartDescription?.text = ""
        }
        
        pieChart.chartDescription?.font = UIFont(name: "Futura-Medium", size: 13)!
        
        // finalize
        pieChart.data = chartData
    }
    
    func updateChart() {
        
        inspiringDataEntry.value = UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "inspiringCounter") as! Double
        inspiringDataEntry.label = "INSPIRATION"
        
        motivatingDataEntry.value = UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "motivatingCounter") as! Double
        motivatingDataEntry.label = "MOTIVATION"
        
        empoweringDataEntry.value = UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "empoweringCounter") as! Double
        empoweringDataEntry.label = "EMPOWERMENT"
        
        numberOfCounterDataEntries = [inspiringDataEntry, motivatingDataEntry, empoweringDataEntry]
        
        updateChartData()
        
    }
    
    // MARK: - Foramtter

}
