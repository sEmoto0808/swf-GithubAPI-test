//
//  DetailUserReaponse.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation

struct DetailUserReaponse: Decodable {
    
    let userName: String?
    let iconURLStr: String?
    let fullName: String?
    let followerCount: Int?
    let followingCount: Int?
    
    private enum CodingKeys: String, CodingKey {
        case userName = "login"
        case iconURLStr = "avatar_url"
        case fullName = "name"
        case followerCount = "followers"
        case followingCount = "following"
    }
}
