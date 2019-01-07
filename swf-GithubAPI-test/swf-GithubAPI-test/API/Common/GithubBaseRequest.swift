//
//  GithubBaseRequest.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation
import APIKit

protocol GithubBaseRequest: Request {}

extension GithubBaseRequest {
    
    // APIのベースURL
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var headerFields: [String: String] {
        
        return ["Authorization":"token a292a25b029c2eb43b6f0d9d0c920746d55cef73"]
    }
}

extension GithubBaseRequest where Response: Decodable {
    
    var dataParser: DataParser {
        return DecodableDataParser()
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        let decoder = JSONDecoder()
        if data.count == 0 {
            let emptyJson = "{}"
            return try decoder.decode(Response.self, from: emptyJson.data(using: .utf8)!)
        } else {
            return try decoder.decode(Response.self, from: data)
        }
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        
        guard (200..<300).contains(urlResponse.statusCode) else {
            
            let decoder = JSONDecoder()
            let obj_decoded = try decoder.decode(GithubRawError.self, from: object as! Data)
            // GithubErrorを生成
            throw GithubError(object: obj_decoded)
        }
        
        return object
    }
}
