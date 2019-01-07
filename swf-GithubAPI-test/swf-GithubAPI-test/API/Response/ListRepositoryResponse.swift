//
//  ListRepositoryResponse.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation

struct ListRepositoryResponse: Decodable {
    
    let name: String?
    let htmlURLStr: String?
    let description: String?
    let starCount: Int?
    let language: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case htmlURLStr = "html_url"
        case description = "description"
        case starCount = "stargazers_count"
        case language = "language"
    }
}
