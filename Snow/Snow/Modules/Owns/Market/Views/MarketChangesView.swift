//
//  MarketChangesView.swift
//  Snow
//
//  Created by kim on 2024/9/26.
//

import UIKit
import DGCharts

/// 大盘异动
class MarketChangesView: UIView {
    private var headerView: MarketsSectionHeaderView = {
        let view = MarketsSectionHeaderView()
        view.titleLabel.text = "大盘异动"
        return view
    }()
    
    private lazy var changeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.hex("FFF7F0")
        label.layer.cornerRadius = 2.5
        label.text = "最新异动"
        label.textColor = UIColor.hex("FF7700")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: .medium)
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "13:32 CRO概念走强"
        label.textColor = .hex("666666")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var zdfLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .hex("FDECEC")
        label.layer.cornerRadius = 1
        label.text = "+2.04%"
        label.textColor = .hex("F04848")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: .medium)
        return label
    }()
    
    // 大盘分时图
    private lazy var olineView: LineChartView = {
        let chartView = LineChartView()
        chartView.drawBordersEnabled = true
        chartView.borderColor = NSUIColor(hex: "E8E8E8")
        chartView.borderLineWidth = 0.5
        chartView.minOffset = 0
        // 基本设置
        chartView.legend.enabled = false // 不显示图例
        // 交互设置
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        chartView.dragEnabled = false
        // 设置 x 轴样式
        chartView.xAxis.drawGridLinesEnabled = true
        chartView.xAxis.gridColor = NSUIColor(hex: "E8E8E8")
        chartView.xAxis.gridLineWidth = 0.5
        chartView.xAxis.labelTextColor = UIColor.hex("#333333")
        chartView.xAxis.labelCount = 5 // 显示 5 条线
        chartView.xAxis.forceLabelsEnabled = true // 必须加上，不然内部处理后显示数量与预期不一致
        chartView.xAxis.axisMinimum = 0
        chartView.xAxis.axisMaximum = 240
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.avoidFirstLastClippingEnabled = true // 避免控件被裁剪
        chartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {value, axis in
            if value == axis!.axisMinimum {
                return "9:30"
            } else if value == axis!.axisMaximum {
                return "15:00"
            } else if value == (axis!.axisMaximum + axis!.axisMinimum) / 2 {
                return "11:30/13:00"
            }
            return ""
        })
        // 设置左侧 y 轴样式
        chartView.leftAxis.drawGridLinesEnabled = true
        chartView.leftAxis.gridColor = NSUIColor(hex: "E8E8E8")
        chartView.leftAxis.gridLineWidth = 0.5
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.leftAxis.labelCount = 5
        chartView.leftAxis.labelPosition = .insideChart
        chartView.leftAxis.axisMinimum = 80
        chartView.leftAxis.axisMaximum = 120
        chartView.leftAxis.yOffset = 0
        chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(block: { value, axis in
            if value == axis!.axisMinimum {
                let color: UIColor = .red
                let attriString = NSAttributedString.init(string: "2772.77", attributes: [.foregroundColor: color])
                return "2772.77"
            } else if value == axis!.axisMaximum {
                return "2989.34"
            }
            return ""
        })
        // 设置右侧 y 轴样式
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        // 准备测试数据
        var dataEntries = [ChartDataEntry]()
        for i in 0..<240 {
            let y = arc4random() % 15 + 100
            let entry = ChartDataEntry(x: Double(i), y: Double(y))
            dataEntries.append(entry)
        }
        let chartDataSet = LineChartDataSet(entries: dataEntries)
        chartDataSet.colors = [NSUIColor.hex("0083FF")]
        // 不绘制转折点
        chartDataSet.drawCirclesEnabled = false
        // 折线模式
        chartDataSet.mode = .cubicBezier
        // 填充绘制
        chartDataSet.fillColor = NSUIColor.hex("C7E4FF").withAlphaComponent(0.5)
        chartDataSet.drawFilledEnabled = true
        let chartData = LineChartData(dataSet: chartDataSet)
        chartView.data = chartData
        return chartView
    }()
    
    private lazy var leftTopLabel: UILabel = {
        let label = UILabel()
        label.text = "2972.22"
        label.textColor = .hex("F04848")
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private lazy var leftBottomLabel: UILabel = {
        let label = UILabel()
        label.text = "2972.22"
        label.textColor = .hex("22A775")
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private lazy var rightTopLabel: UILabel = {
        let label = UILabel()
        label.text = "3.12%"
        label.textColor = .hex("F04848")
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private lazy var rightBottomLabel: UILabel = {
        let label = UILabel()
        label.text = "-3.12%"
        label.textColor = .hex("22A775")
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    // 获取最高最低
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(headerView)
        addSubview(changeLabel)
        addSubview(contentLabel)
        addSubview(zdfLabel)
        addSubview(olineView)
        olineView.addSubview(leftTopLabel)
        olineView.addSubview(leftBottomLabel)
        olineView.addSubview(rightTopLabel)
        olineView.addSubview(rightBottomLabel)
        
        headerView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(10)
            make.height.equalTo(40)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.left.equalTo(headerView)
            make.top.equalTo(headerView.snp.bottom).offset(12)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(changeLabel)
            make.left.equalTo(changeLabel.snp.right).offset(20)
        }
        zdfLabel.snp.makeConstraints { make in
            make.centerY.equalTo(changeLabel)
            make.left.equalTo(contentLabel.snp.right).offset(5)
        }
        
        olineView.snp.makeConstraints { make in
            make.left.equalTo(headerView)
            make.right.equalTo(headerView)
            make.top.equalTo(changeLabel.snp.bottom).offset(12)
            make.height.equalTo(300)
            make.bottom.equalTo(-10)
        }
        
        leftTopLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
        }
        leftBottomLabel.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalTo(leftTopLabel)
        }
        rightTopLabel.snp.remakeConstraints { make in
            make.top.equalTo(leftTopLabel)
            make.right.equalToSuperview().offset(-5)
        }
        rightBottomLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(leftBottomLabel)
            make.right.equalTo(rightTopLabel)
        }
    }
}
