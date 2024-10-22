//
//  HomeViewModel.swift
//  Snow
//
//  Created by kim on 2024/7/25.
//

import Foundation
import UIKit

class HomeViewModel {
    
    var datas: Observable<[HomeCellViewModel]>
    
    init() {
        datas = Observable([])
    }

    func requestData() {
        var params: [String: Any] = [:]
        params["category"] = 200
        params["count"] = 8
        params["first_refresh"] = false
        params["link_id"] = "862E46D8-E025-4647-BB24-5D7ECEBB3C87"
        params["max_id"] = 0
        params["network_type"] = "WIFI"
        params["page_id"] = 1
        params["req_seq"] = 1
        params["require_advert"] = false
        params["required_status"] = true
        params["since_id"] = 1721981388635 // 上一次请求时间，可以为空，为空的情况下，接口会返回当前时间戳，记录下来下次请求使用
        params["_"] = 1721981493939 // 这一次请求时间
        params["x"] = 0.862
        params["_s"] = "46075c"
        params["_t"] = "\(UUID().uuidString).4993337198.1721981350099.1721981387700"
        NetworkTool.shareInstance.get(homeFlowPath, params: params) { res in
            do {
                let model = try JSONDecoder().decode(HomeFlowModel.self, from: res)
                print(model)
                
                let value = model.list.map {
                    let vm = HomeCellViewModel()
                    
                    if let post = $0.post {
                        vm.name.value = post.user.screen_name
                        vm.image.value = post.user.photo_domain + post.user.profile_image_url.split(separator: ",").last!
                        let content = try? NSMutableAttributedString(
                            data: post.topic_desc.data(using: .utf8)!,
                            options: [
                                .documentType: NSAttributedString.DocumentType.html,
                                .characterEncoding: String.Encoding.utf8.rawValue,
                            ],
                            documentAttributes: nil
                        )
                        let para = NSMutableParagraphStyle()
                        para.lineSpacing = 5
                        content?.addAttributes([
                            .font: UIFont.systemFont(ofSize: 15),
                            .paragraphStyle: para
                        ], range: NSRange(location: 0, length: content!.length))
                        vm.content.value = content
                        vm.focus.value = post.user.following
                    }
                    
                    vm.publishTime.value = $0.original_status.timeBefore
                    
                    
                    
                    
                    return vm
                }
                self.datas.value = value
            } catch {
                print(error)
            }
            
            
        } failureBlock: { errMsg in
            print(errMsg)
        }

    }
}
