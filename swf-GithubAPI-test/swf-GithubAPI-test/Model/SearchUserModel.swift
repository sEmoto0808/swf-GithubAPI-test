//
//  SearchUserModel.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation
import RxSwift

final class SearchUserModel {
    
    struct Status {
        var isLoading = PublishSubject<Bool>()
        var success = PublishSubject<[ListUser]>()
        var failed = PublishSubject<GithubError>()
    }
    
    private let _status = SearchUserModel.Status.init()
    private let disposeBag = DisposeBag()
    
    func status() -> SearchUserModel.Status {
        return _status
    }
    
    func rx_get(from keyword: Observable<String>) {
        
        keyword
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest({ [weak self] text -> Observable<GithubAPI.SearchUser.Response> in
                guard let weakSelf = self else { return Observable.just(ListUserResponse(users: nil)) }
                weakSelf._status.isLoading.onNext(true)
                // APIからデータを取得する
                return APIClient().send(withRequest: GithubAPI.SearchUser(keyword: text))
                    .catchError({ [weak self] error in
                        // Failure
                        weakSelf._status.isLoading.onNext(false)
                        guard let weakSelf = self, let error = error as? GithubError else {
                            self?._status.failed.onNext(GithubError(object: GithubRawError.init(err: [])))
                            return Observable.just(ListUserResponse(users: nil))
                        }
                        weakSelf._status.failed.onNext(error)
                        return Observable.just(ListUserResponse(users: nil))
                    })
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                // Success
                print("success")
                guard let weakSelf = self,
                    let users = response.users
                    else { return }
                weakSelf._status.success.onNext(users)
                weakSelf._status.isLoading.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}
