//
//  GithubError.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation

struct GithubError: Error {
    
    let err: [ErrorInfo]?
    
    init(object: GithubRawError) {
        err = object.err
    }
}
