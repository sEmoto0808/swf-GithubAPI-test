//
//  GetUserDetailModel.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation
import RxSwift

final class GetUserDetailModel {
    
    struct Status {
        var isLoading = PublishSubject<Bool>()
        var success = PublishSubject<DetailUser>()
        var failed = PublishSubject<GithubError>()
    }
    
    private let _status = GetUserDetailModel.Status.init()
    private let disposeBag = DisposeBag()
    
    func status() -> GetUserDetailModel.Status {
        return _status
    }
    
    func rx_get(from username: Observable<String>) {
        
        username
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest({ [weak self] username -> Observable<GithubAPI.GetUserDetail.Response> in
                guard let weakSelf = self else { return Observable.just(DetailUserReaponse(userName: nil,
                                                                                           iconURLStr:nil,
                                                                                           fullName:nil,
                                                                                           followerCount:nil,
                                                                                           followingCount:nil)) }
                weakSelf._status.isLoading.onNext(true)
                // APIからデータを取得する
                return APIClient().send(withRequest: GithubAPI.GetUserDetail(username: username))
                    .catchError({ [weak self] error in
                        // Failure
                        weakSelf._status.isLoading.onNext(false)
                        guard let weakSelf = self, let error = error as? GithubError else {
                            self?._status.failed.onNext(GithubError(object: GithubRawError.init(err: [])))
                            return Observable.just(DetailUserReaponse(userName: nil,
                                                                      iconURLStr:nil,
                                                                      fullName:nil,
                                                                      followerCount:nil,
                                                                      followingCount:nil))
                        }
                        weakSelf._status.failed.onNext(error)
                        return Observable.just(DetailUserReaponse(userName: nil,
                                                                  iconURLStr:nil,
                                                                  fullName:nil,
                                                                  followerCount:nil,
                                                                  followingCount:nil))
                    })
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                // Success
                print("success")
                guard let weakSelf = self
                    else { return }
                weakSelf._status.success.onNext(DetailUser(response: response))
                weakSelf._status.isLoading.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}
