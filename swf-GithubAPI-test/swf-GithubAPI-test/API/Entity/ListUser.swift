//
//  ListUser.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation

// ユーザ検索の結果で表示する情報
struct ListUser: Decodable {
    
    let userName: String?
    let iconURLStr: String?
    
    private enum CodingKeys: String, CodingKey {
        case userName = "login"
        case iconURLStr = "avatar_url"
    }
}
