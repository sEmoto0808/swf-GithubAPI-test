//
//  DetailUser.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation

// ユーザリポジトリ画面で表示するユーザ情報
struct DetailUser: Decodable {
    
    let userName: String?
    let iconURLStr: String?
    let fullName: String?
    let followerCount: Int?
    let followingCount: Int?
    
    init(response: DetailUserReaponse) {
        self.userName = response.userName
        self.iconURLStr = response.iconURLStr
        self.fullName = response.fullName
        self.followerCount = response.followerCount
        self.followingCount = response.followingCount
    }
}
