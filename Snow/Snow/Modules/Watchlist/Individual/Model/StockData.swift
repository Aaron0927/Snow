//
//  StockData.swift
//  Snow
//
//  Created by kim on 2024/8/19.
//

import Foundation

struct StockResponse: Codable {
    let msg: String
    let code: Int
    let data: [StockData]
}

struct StockData: Codable {
    var ticker: String // 股票代码
    var date: String // 日期
    var open: Double // 开盘价
    var high: Double // 最高价
    var low: Double // 最低价
    var close: Double // 收盘价
    var volumn: Int? // 成交量
}
