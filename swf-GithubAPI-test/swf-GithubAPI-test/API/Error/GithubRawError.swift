//
//  GithubRawError.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation

struct GithubRawError: Decodable {
    
    let err: [ErrorInfo]?
    
    private enum CodingKeys: String, CodingKey {
        
        case err
    }
}

struct ErrorInfo: Decodable {
    
    let code: String
    let msg: String
    
    private enum CodingKeys: String, CodingKey {
        
        case code
        case msg
    }
}
