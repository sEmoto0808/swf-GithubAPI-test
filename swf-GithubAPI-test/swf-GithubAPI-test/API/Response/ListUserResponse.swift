//
//  ListUserResponse.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation

struct ListUserResponse: Decodable {
    
    let users: [ListUser]?
    
    private enum CodingKeys: String, CodingKey {
        case users = "items"
    }
}
