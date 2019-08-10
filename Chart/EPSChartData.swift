//
//  EPSChartView.swift
//  PennyPlus
//
//  Created by Balagurubaran Kalingarayan on 2/3/18.
//  Copyright © 2018 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import Charts

class EPSChartData:NSObject {
    
    
    
    func loadEPSDataView(chartView: PieChartView) {
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        //        chartView.legend = l
        
        // entry label styling
        chartView.entryLabelColor = .black
        chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        chartView.chartDescription?.text = "EPS"
    
        //chartView.setExtraOffsets(left: 70, top: -30, right: 70, bottom: 10)
        
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
        let entries = EPSData.map { (eps) -> PieChartDataEntry in
            if let actual = eps.actual{
                let displayText = actual >= 0.0 ? eps.year.description : ("-" +  eps.year.description)
                return PieChartDataEntry(value: abs(actual), label: displayText)
            }
            return PieChartDataEntry(value: 0.0, label: "N/A")
        }
        
        let set = PieChartDataSet(values: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
    
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .decimal
        pFormatter.maximumFractionDigits = 3
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = ""
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 8, weight: .medium))
        data.setValueTextColor(.white)
        
        chartView.data = data
        chartView.highlightValues(nil)

    }
    
    func loadEPSBarCHart(chartView:BarChartView){
       
        barCharSettings(chartView:chartView)
        
        let actualEPSEntry = EPSData.map { (eps) -> BarChartDataEntry in
            return BarChartDataEntry(x:Double(eps.index), y:  eps.actual!)
        }
        let estimatedEPSEntry = EPSData.map { (eps) -> BarChartDataEntry in
            return BarChartDataEntry(x:Double(eps.index), y:  eps.estimated!)
        }
        
        let actualEPSBarColor = estimatedEPSEntry.map { (entry) -> NSUIColor in
            return entry.y >= 0 ? UIColor.stockEmc2Green : UIColor.stockEmc2Red
        }
        
        let estimatedEPSBarColor = estimatedEPSEntry.map { (entry) -> NSUIColor in
            return entry.y >= 0 ? UIColor.stockEmc2TealBlue : UIColor.stockEmc2Red
        }
        
        
        let actualEPSSet = BarChartDataSet(values: actualEPSEntry, label: "Actual")
        //actualEPSSet.setColor(UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1))
        actualEPSSet.colors = actualEPSBarColor
        
        let estimatedEPSSet = BarChartDataSet(values: estimatedEPSEntry, label: "Estimated")
        //estimatedEPSSet.setColor(UIColor(red: 255/255, green: 102/255, blue: 0/255, alpha: 1))
        estimatedEPSSet.colors = estimatedEPSBarColor
    
        let chartData = BarChartData(dataSets: [estimatedEPSSet,actualEPSSet])
        chartData.setValueFont(.systemFont(ofSize: 13))
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
        chartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        chartData.barWidth = 0.25 / (4.0/Double(EPSData.count))
        
        //let groupSpace = 0.35 + (0.35 / (4.0/Double(EPSData.count)))
        //let barSpace = 0.05 * (4.0/Double(EPSData.count))
            
        chartData.groupBars(fromX: 0, groupSpace: 0.35, barSpace: 0.05)
        //chartData.groupWidth(groupSpace: <#T##Double#>, barSpace: <#T##Double#>)
        
        chartView.data = chartData
    }
    
    
    
    private func barCharSettings(chartView:BarChartView){
        
        //chartView.setExtraOffsets(left: 20, top: -30, right: 20, bottom: 10)
        
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = true
        chartView.chartDescription?.text = "Earning per Share"
        
        
        chartView.rightAxis.enabled = true
        chartView.animate(yAxisDuration: 1.5)
        chartView.fitBars = true
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = false
        xAxis.labelTextColor = .lightGray
        xAxis.labelCount = EPSData.count
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 1
        let QlabelText:[String] = EPSData.compactMap { (eachEps) -> String in
            return eachEps.year
        }
        xAxis.valueFormatter = IndexAxisValueFormatter(values: QlabelText)
        xAxis.axisMinimum = 0
        
        let minEstimated = EPSData.min(by: { (a, b) -> Bool in
            if let a1 = a.estimated, let b1 = b.estimated {
                return (a1 < b1)
            }
            return false
        })
        
        let minActual = EPSData.min(by: { (a, b) -> Bool in
            if let a1 = a.actual, let b1 = b.actual {
                return (a1 < b1)
            }
            return false
        })
        
        var min = minActual?.actual
        if((minEstimated?.estimated)! <  (minActual?.actual)!){
            min = minEstimated?.estimated
        }
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        //leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
    
        if(min! < 0.0){
            leftAxis.axisMinimum = min!  + (min!/4)
        }
    }
}
//
//extension EPSChartData: IAxisValueFormatter {
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        return EPSQLabels[min(max(Int(value), 0), EPSQLabels.count - 1)]
//    }
//}

