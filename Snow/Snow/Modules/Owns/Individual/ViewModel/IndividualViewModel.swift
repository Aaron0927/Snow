//
//  IndividualViewModel.swift
//  Snow
//
//  Created by kim on 2024/8/19.
//

import Foundation

private let token = "c2bf737b73a74f6fb1685e9a5423b340"

class IndividualViewModel {
    
    
}

// MARK: - 网络请求
extension IndividualViewModel {
    // 历史日 K 线
    // https://tsanghi.com/api/fin/stock/XSHG/daily?token=c2bf737b73a74f6fb1685e9a5423b340&ticker=600519&order=2
    func requestData(_ completion: @escaping ([StockData]) -> Void) {
        // 测试
        let json = """
        {
          "msg": "操作成功",
          "code": 200,
          "data": [
            {
              "ticker": "600519",
              "date": "2024-08-19",
              "open": 1432,
              "high": 1458.88,
              "low": 1425,
              "close": 1425.44,
              "volume": 20433
            },
            {
              "ticker": "600519",
              "date": "2024-08-16",
              "open": 1426.79,
              "high": 1435.92,
              "low": 1417.01,
              "close": 1431.2,
              "volume": 16455
            },
            {
              "ticker": "600519",
              "date": "2024-08-15",
              "open": 1405.03,
              "high": 1435.99,
              "low": 1403.95,
              "close": 1426.89,
              "volume": 23039
            },
            {
              "ticker": "600519",
              "date": "2024-08-14",
              "open": 1423.01,
              "high": 1424.9,
              "low": 1412.02,
              "close": 1413.3,
              "volume": 13414
            },
            {
              "ticker": "600519",
              "date": "2024-08-13",
              "open": 1433,
              "high": 1435,
              "low": 1412.01,
              "close": 1423.01,
              "volume": 16308
            },
            {
              "ticker": "600519",
              "date": "2024-08-12",
              "open": 1430,
              "high": 1443,
              "low": 1426.58,
              "close": 1436.1,
              "volume": 13632
            },
            {
              "ticker": "600519",
              "date": "2024-08-09",
              "open": 1460.03,
              "high": 1469,
              "low": 1436.8,
              "close": 1436.8,
              "volume": 30138
            },
            {
              "ticker": "600519",
              "date": "2024-08-08",
              "open": 1411,
              "high": 1448.18,
              "low": 1409,
              "close": 1430.69,
              "volume": 25131
            },
            {
              "ticker": "600519",
              "date": "2024-08-07",
              "open": 1405.5,
              "high": 1421.99,
              "low": 1398.3,
              "close": 1415.5,
              "volume": 20622
            },
            {
              "ticker": "600519",
              "date": "2024-08-06",
              "open": 1422,
              "high": 1424,
              "low": 1394.01,
              "close": 1404.7,
              "volume": 27444
            }
          ]
        }
        """
        let data = json.data(using: .utf8)!
        let stockResponse = try! JSONDecoder().decode(StockResponse.self, from: data)
        completion(stockResponse.data)
        return
        
        let params: [String: Any] = ["token": "demo", "ticker": "600519", "order": 2]
        
        NetworkTool.shareInstance.get(domain: .tsanghi, "/api/fin/stock/XSHG/daily", params: params) { data in
            do {
                let stockResponse = try JSONDecoder().decode(StockResponse.self, from: data)
                completion(stockResponse.data)
            } catch {
                print(error)
            }
        } failureBlock: { errMsg in
            
        }
    }
}
