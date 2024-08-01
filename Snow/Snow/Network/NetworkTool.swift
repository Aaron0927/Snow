//
//  NetworkTool.swift
//  Snow
//
//  Created by kim on 2024/7/25.
//

import Foundation

let domain = "https://api.xueqiu.com"

class NetworkTool {
    static let shareInstance = NetworkTool()
    private init() {}
    
    typealias ResponseSuccessBlock = (Data) -> Void
    typealias ResponseFailBlock = (String) -> Void
    
    func get(_ path: String, params: [String: Any]?, successBlock: @escaping ResponseSuccessBlock, failureBlock: @escaping ResponseFailBlock) {
        request(method: "GET", path, params: params, successBlock: successBlock, failureBlock: failureBlock)
    }
    
    func post(_ path: String, params: [String: Any]?, successBlock: @escaping ResponseSuccessBlock, failureBlock: @escaping ResponseFailBlock) {
        request(method: "POST", path, params: params, successBlock: successBlock, failureBlock: failureBlock)
    }
    
    
    private func request(method: String, _ path: String, params: [String: Any]?, _ body: Data? = nil, successBlock: @escaping ResponseSuccessBlock, failureBlock: @escaping ResponseFailBlock) {
        guard let url = generateURL(path: path, params: params) else {
            failureBlock("错误的URL:\(path)")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.allHTTPHeaderFields = ["cookie": "xq_a_token=8308b40484eb4b4e8c19c2825f24027c332a9080;xq-dj-token=8308b40484eb4b4e8c19c2825f24027c332a9080;xq_id_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ1aWQiOjQ5OTMzMzcxOTgsImlzcyI6InVjIiwiZXhwIjoxNzI0NTU0MDM4LCJjdG0iOjE3MjE5ODEzODc1ODQsImNpZCI6IldpQ2lteHBqNUgifQ.NMO5sugTyYfFpHwAnEYFDto6XWntPYSgEinukSFgyXDAF14aRcQeIjHEQIlEfd1oRhPLc862C19-nOh_Xs_rPzEH2X3wUJY_FmYbbYDF48-_TKqoYxQvgpJTafTxhpuBaiJRZCJTxgg5M9hKUTP0dLTMKZjW1UObwFNPfZjPN9qXVugi88xKoi8WxM0Zw8dyZcZx1uXxRUCtknuH3eBCnP-Y2HWPvS2u8Fg2vK478BR8uZNC1WH3M43XGK1I99i7f78YvdhamE39fFwcXti0B1XnHd98TN4aXRP0Z-e4HniuVk50K4-Y1qRklhgILGeQdDi9gsy0C2cbX3-PT4Z1wA;u=4993337198;xq_is_login=1;xid=100528621;session_id=07ce37721d82935a921a96a8ea50476a4f9edde002ff994cf50be8b66060ceba"]
        
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 6
        configuration.timeoutIntervalForRequest = 60.0
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    failureBlock(error!.localizedDescription)
                    return
                }
                
                if let data = data {
                    successBlock(data)
                } else {
                    failureBlock("数据异常")
                }
            }
        }
        task.resume()
    }
    
    
    // 将参数转换成data
    private func generateURL(path: String, params: [String: Any]?) -> URL? {
        guard let params = params, !params.isEmpty else {
            return nil
        }
        
        var components = URLComponents(string: domain)
        components?.path = path
        var queryItems = [URLQueryItem]()
        
        for (key, value) in params {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            queryItems.append(queryItem)
        }
        
        components?.queryItems = queryItems
        
        return components?.url
    }
}
