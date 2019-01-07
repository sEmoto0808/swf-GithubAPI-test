//
//  Repository.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    
    let name: String?
    let htmlURLStr: String?
    let description: String?
    let starCount: Int?
    let language: String?
    
    init(response: ListRepositoryResponse) {
        
        self.name = response.name
        self.htmlURLStr = response.htmlURLStr
        self.description = response.description
        self.starCount = response.starCount
        self.language = response.language
    }
}
