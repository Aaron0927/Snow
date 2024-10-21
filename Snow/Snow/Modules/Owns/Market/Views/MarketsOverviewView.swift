//
//  MarketsOverviewView.swift
//  Snow
//
//  Created by kim on 2024/9/25.
//

import UIKit
import DGCharts

/// 市场总览视图
class MarketsOverviewView: UIView {
    // MARK: - 懒加载属性
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "市场总览"
        label.textColor = UIColor.hex("#333333")
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow_right")
        return imageView
    }()
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = UIColor.hex("#F7F8FA")
        btn.layer.cornerRadius = 9
        btn.setTitle("收起", for: .normal)
        btn.setTitleColor(UIColor.hex("#666666"), for: .normal)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpOutside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 8)
        return btn
    }()
    
    private lazy var hotProgressView: HotProgressView = {
        let view = HotProgressView(progress: 0.75)
        view.backgroundColor = UIColor.hex("#E8E8E8")
        view.layer.cornerRadius = 2
        return view
    }()
    
    private lazy var hotTagLabel: UILabel = {
        let label = UILabel()
        label.text = "大盘热度"
        label.textColor = UIColor.hex("#333333")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var hotLabel: UILabel = {
        let label = UILabel()
        label.text = "75%"
        label.textColor = UIColor.hex("#F54446")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var hstack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            hotProgressView, hotTagLabel, hotLabel, arrowImageView
        ])
        stack.axis = .horizontal
        stack.spacing = 5
        return stack
    }()
    
    // 柱状图
    private lazy var barChartView: BarChartView = {
        let chartView = BarChartView()
        // 基本设置
        chartView.drawValueAboveBarEnabled = true // 数值显示在柱子的上方
        chartView.legend.enabled = false // 不显示图例
        // 交互设置
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        chartView.dragEnabled = false
        // 设置 x 轴样式
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelTextColor = UIColor.hex("#333333")
        chartView.xAxis.labelCount = 11
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.valueFormatter = MarketOveriewXAxisValueFormatter()
        // 设置左侧 y 轴样式
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        // 设置右侧 y 轴样式
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        // 准备测试数据
        var dataEntries = [BarChartDataEntry]()
        for i in 0..<11 {
            let y = arc4random() % 100 + 50
            let entry = BarChartDataEntry(x: Double(i), y: Double(y))
            dataEntries.append(entry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries)
        chartDataSet.colors = [UIColor.hex("22A775"), UIColor.hex("22A775"), UIColor.hex("22A775"), UIColor.hex("22A775"), UIColor.hex("22A775"), UIColor.hex("787C86"), UIColor.hex("F04848"), UIColor.hex("F04848"), UIColor.hex("F04848"), UIColor.hex("F04848"), UIColor.hex("F04848")] // 设置柱子的颜色
        chartDataSet.cornerRadius = 5 // 设置圆角
        chartDataSet.roundedCorners = [.topLeft, .topRight]
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.barWidth = 0.7 // 设置柱子宽度占刻度区域的比例
        chartView.data = chartData
        
        return chartView
    }()
    
    // 涨跌家数对比图
    private lazy var comparisonView: ComparisonBarView = {
        let view = ComparisonBarView()
        return view
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(closeBtn)
        addSubview(hstack)
        addSubview(barChartView)
        addSubview(comparisonView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(0)
        }
        closeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.width.equalTo(32)
            make.height.equalTo(18)
        }
        hstack.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(0)
        }
        hotProgressView.snp.makeConstraints { make in
            make.width.equalTo(4)
            make.height.equalTo(17)
        }
        barChartView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(-0)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(135)
        }
        comparisonView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(barChartView.snp.bottom).offset(5)
            make.height.equalTo(20)
            make.bottom.equalTo(-5)
        }
        comparisonView.leftProgress = 0.5
        comparisonView.middleProgress = 0.1
        comparisonView.rightProgress = 0.4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeAction() {
        
    }
}

private class MarketOveriewXAxisValueFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let texts = ["跌停", ">7", "5-7", "3-5", "0-3", "0", "0-3", "3-5", "5-7", ">7", "涨停"]
        return texts[Int(value)]
    }
}

