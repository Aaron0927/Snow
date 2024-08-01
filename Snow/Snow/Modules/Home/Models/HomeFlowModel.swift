//
//  HomeFlowModel.swift
//  Snow
//
//  Created by kim on 2024/7/25.
//

import Foundation

struct HomeFlowModel: Codable {
    var list: [Flow]
    var query_id: Int
    
    struct Flow: Codable {
//        var id: Int
//        var category: Int
        var data: String // 是一个 json 字符串
//        var column: String
//        var pass_through: String
        var original_status: OriginalStatus
        
        var post: Post? {
            guard let josnData = data.data(using: .utf8) else {
                return nil
            }
            let post = try? JSONDecoder().decode(Post.self, from: josnData)
            return post
        }
    }
    
    // 详情页的
    struct OriginalStatus: Codable {
        var text: String
        var created_at: Int
        var retweet_count: Int
        var reply_count: Int
        var fav_count: Int
        var description: String
        var timeBefore: String
    }
}

struct Post: Codable {
    let id: Int
    let title: String
    let description: String
    let target: String
    let reply_count: Int
    let retweet_count: Int
    let topic_title: String
    let topic_desc: String
    let topic_symbol: String?
    let topic_pic: String?
    let topic_pic_hd: String?
    let pic_type: Int
    let first_pic: String?
    let pic_size: PicSize
    let pic: String
    let pic_sizes: [String]
    let cover_pic: String?
    let user: User
    let promotion: Bool
    let answers: [String]?
    let view_count: Int
    let created_at: TimeInterval
    let link_stock_desc: String
    let link_stock_symbol: String
    let strategy_id: Int
    let feedback: [String]
    let tag: String?
    let card: [String]?
    let quote_cards: [String]?
    let source: String
    let retweeted_status: String?
    let like_count: Int
    let liked: Bool
    let mode: Int
    let symbol_id: String?
    let reply_user_images: [String]?
    let reply_user_count: Int
    let offer: String?
    let user_id: Int
    let longTextForIOS: Bool
    let text: String
}

struct PicSize: Codable {
    let width: Int
    let height: Int
}

struct User: Codable {
    let id: Int
    let profile: String
    let description: String
    let following: Bool
    let screen_name: String
    let profile_image_url: String
    let photo_domain: String
    let verified_infos: [VerifiedInfo]
    let followers_count: Int
    let recommend_description: String?
}

struct VerifiedInfo: Codable {
    let data: String?
    let verified_type: String
    let verified_desc: String
}
