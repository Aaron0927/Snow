//
//  IndividualController.swift
//  Snow
//
//  Created by kim on 2024/8/19.
//

import UIKit
import DGCharts
import TGCoreKit

// 个股页面控制器
class IndividualController: BaseViewController {
    // MARK: - Properties
    private let viewModel = IndividualViewModel()
    
    private lazy var candleChartView: CandleStickChartView = {
        let chartView = CandleStickChartView()
        chartView.frame = CGRect(x: 0, y: kNavBarH + kStatusBarH, width: kScreenW, height: 300)
        return chartView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        requestData()
    }
}

// MARK: - 设置 UI
extension IndividualController {
    private func setupUI() {
        view.addSubview(candleChartView)
        
        configureChartAppearance()
    }
}

// MARK: - 请求数据
extension IndividualController {
    private func requestData() {
        viewModel.requestData { [weak self] datas in
            self?.setCandleData(candles: datas.reversed())
        }
    }
    
    private func setCandleData(candles: [StockData]) {
        var candleDataEntries: [CandleChartDataEntry] = []
        
        for (index, candle) in candles.enumerated() {
            let entry = CandleChartDataEntry(x: Double(index), shadowH: candle.high, shadowL: candle.low, open: candle.open, close: candle.close)
            candleDataEntries.append(entry)
        }
        
        let dataSet = CandleChartDataSet(entries: candleDataEntries, label: "K线图")
        dataSet.colors = candles.map { $0.close >= $0.open ? .red : .green }
        dataSet.drawValuesEnabled = false // 隐藏数据值
        
        let data = CandleChartData(dataSet: dataSet)
        candleChartView.data = data
        
        setupChartView(candles: candles)
        
        // 配置图表可滑动（必须设置在获取数据之后）
        let visibleXRange: Double = 50
        candleChartView.setVisibleXRangeMaximum(visibleXRange)
        // 如果数据不足30条，设置最小可见范围
        if candleDataEntries.count < Int(visibleXRange) {
            candleChartView.setVisibleXRangeMinimum(visibleXRange)
        }
        candleChartView.autoScaleMinMaxEnabled = false // 禁止自动缩放
//        candleChartView.dragEnabled = true
//        candleChartView.dragDecelerationFrictionCoef = 0.9
        
        // 禁止拖拽后自动缩放
        candleChartView.scaleXEnabled = false
        candleChartView.scaleYEnabled = false
        
        // 将图表的X轴缩放到适应30条数据
        let scaleX = CGFloat(candleDataEntries.count) / CGFloat(visibleXRange)
        candleChartView.zoom(scaleX: scaleX, scaleY: 1, x: 0, y: 0)
        
        // 禁止自动适应内容大小
        candleChartView.fitScreen()
        
        // 每个柱子是平分宽度的，设置 barSpace是柱子两边的间隔
        dataSet.barSpace = 0.2 // 调整柱子的宽度，确保宽度适合显示30条数据
        
        candleChartView.notifyDataSetChanged()
        
        // 自动滚动到最右侧
        if let lastCandleIndex = candles.indices.last {
            candleChartView.moveViewToX(Double(lastCandleIndex))
        }
    }
    
    private func setupChartView(candles: [StockData]) {
        // 自定义 x 轴
        let xAxis = candleChartView.xAxis
        xAxis.valueFormatter = DateValueFormatter(dates: candles.map { $0.date })
        xAxis.granularity = 50.0 / 3.0
        xAxis.granularityEnabled = true
    }
    
    // 配置图表外观
    private func configureChartAppearance() {
        // 整体设置
        // 缩放
        candleChartView.scaleXEnabled = true
        candleChartView.scaleYEnabled = false
        
        candleChartView.legend.enabled = false // 隐藏 legend
        
        
        // x 轴设置
        candleChartView.xAxis.labelCount = 3 // 设置显示的标签数量
        candleChartView.xAxis.drawGridLinesEnabled = false // 显示分割线
        candleChartView.xAxis.gridLineWidth = 0.5
        candleChartView.xAxis.gridColor = UIColor(hex: "#00000012")
        candleChartView.xAxis.granularity = 1.0 // 间隔
        candleChartView.xAxis.drawAxisLineEnabled = true // 绘制外围的坐标线
        candleChartView.xAxis.labelPosition = .bothSided
        
        
        // 左边 y 轴设置
        candleChartView.leftAxis.drawLabelsEnabled = true // 启用 Y 轴标签
        candleChartView.leftAxis.labelCount = 3
        candleChartView.leftAxis.enabled = true
        candleChartView.leftAxis.labelPosition = .outsideChart // 文字显示在 y 轴内测
        candleChartView.leftAxis.drawGridLinesEnabled = false // 显示分割线
        candleChartView.leftAxis.gridLineWidth = 0.5
        candleChartView.leftAxis.gridColor = UIColor(hex: "#00000012")
        candleChartView.leftAxis.drawAxisLineEnabled = true // 绘制外围的坐标线
        
        // 右边 y 轴设置
        candleChartView.rightAxis.enabled = true
        candleChartView.rightAxis.labelCount = 3
        candleChartView.rightAxis.drawLabelsEnabled = false
        candleChartView.rightAxis.drawGridLinesEnabled = false
        candleChartView.rightAxis.gridLineWidth = 0.5
        candleChartView.rightAxis.gridColor = UIColor(hex: "#00000012")
        candleChartView.rightAxis.drawAxisLineEnabled = true // 绘制外围的坐标线
    }
}

// MARK: - 自定义K 线图的 x 轴
class DateValueFormatter: AxisValueFormatter {
    private let dates: [String]
    private let dateFormat: DateFormatter

    init(dates: [String]) {
        self.dates = dates
        self.dateFormat = DateFormatter()
        self.dateFormat.dateFormat = "yyyy-MM-dd"
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        guard index >= 0 && index < dates.count else { return "" }
        guard let date = dateFormat.date(from: dates[index]) else { return "" }
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd"
        return dateFormat.string(from: date)
    }
}
