//
//  APIClient.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation
import APIKit
import RxSwift

final class APIClient {
    
    func send<T: Request>(withRequest request: T) -> Observable<T.Response> {
        
        return Observable
            .create { observer in
                let task = Session.send(request) { result in
                    switch result {
                    case .success(let res):
                        observer.on(.next(res))
                        observer.on(.completed)
                    case .failure(.responseError(let err as GithubError)):
                        observer.onError(err)
                    case .failure(let err):
                        observer.onError(err)
                    }
                }
                return Disposables.create {
                    task?.cancel()
                }
        }
    }
}

