//
//  GithubRequest.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation
import APIKit

final class GithubAPI {
    
    struct SearchUser: GithubBaseRequest {
        
        typealias Response = ListUserResponse
        
        let method: HTTPMethod = .get
        let path = "/search/users"
        var parameters: Any? {
            var params = [String: Any]()
            params["q"] = keyword
            return params
        }
        
        let keyword: String
    }
    
    struct GetUserDetail: GithubBaseRequest {
        
        typealias Response = DetailUserReaponse
        
        let method: HTTPMethod = .get
        var path:String {
            return "/users/\(username)"
        }
        
        let username: String
    }
    
    struct GetUserRepository: GithubBaseRequest {
        
        typealias Response = [ListRepositoryResponse]
        
        let method: HTTPMethod = .get
        var path:String {
            return "/users/\(username)/repos"
        }
        
        let username: String
    }
}
