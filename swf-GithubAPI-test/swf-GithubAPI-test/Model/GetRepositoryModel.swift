//
//  GetRepositoryModel.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation
import RxSwift

final class GetRepositoryModel {
    
    struct Status {
        var isLoading = PublishSubject<Bool>()
        var success = PublishSubject<[Repository]>()
        var failed = PublishSubject<GithubError>()
    }
    
    private let _status = GetRepositoryModel.Status.init()
    private let disposeBag = DisposeBag()
    
    func status() -> GetRepositoryModel.Status {
        return _status
    }
    
    func rx_get(from username: Observable<String>) {
        
        username
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest({ [weak self] username -> Observable<GithubAPI.GetUserRepository.Response> in
                guard let weakSelf = self else { return Observable.just([]) }
                weakSelf._status.isLoading.onNext(true)
                // APIからデータを取得する
                return APIClient().send(withRequest: GithubAPI.GetUserRepository(username: username))
                    .catchError({ [weak self] error in
                        // Failure
                        weakSelf._status.isLoading.onNext(false)
                        guard let weakSelf = self, let error = error as? GithubError else {
                            self?._status.failed.onNext(GithubError(object: GithubRawError.init(err: [])))
                            return Observable.just([])
                        }
                        weakSelf._status.failed.onNext(error)
                        return Observable.just([])
                    })
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                // Success
                print("success")
                guard let weakSelf = self
                    else { return }
                var repos = [Repository]()
                for repo in response {
                    let repository = Repository(response: repo)
                    repos.append(repository)
                }
                weakSelf._status.success.onNext(repos)
                weakSelf._status.isLoading.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}
