//
//  GetUserDetailViewModel.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class GetUserDetailViewModel {
    
    struct Input {
        var username: Observable<String>
    }
    
    struct Output {
        var isLoading: Driver<Bool>
        var detailUser: Driver<DetailUser>
        var failed: Driver<GithubError>
    }
    
    // MARK: - Properties
    
    // Viewから受け取るトリガー
    private var _input: GetUserDetailViewModel.Input!
    // Viewにデータをバインドする
    private var _output: GetUserDetailViewModel.Output!
    // GithubAPIからユーザ詳細を取得するModel
    private let getUserDetailModel = GetUserDetailModel()
    
    // MARK: - Init
    
    init(trigger: GetUserDetailViewModel.Input) {
        
        _input = trigger
        
        getUserDetailModel.rx_get(from: _input.username)
        
        _output = GetUserDetailViewModel.Output.init(
            isLoading:getUserDetailModel.status().isLoading
                .asDriver(onErrorJustReturn: false),
            detailUser: getUserDetailModel.status().success
                .asDriver(onErrorJustReturn: DetailUser(response:
                    DetailUserReaponse(
                        userName: nil,
                        iconURLStr:nil,
                        fullName:nil,
                        followerCount:nil,
                        followingCount:nil))),
            failed: getUserDetailModel.status().failed
                .asDriver(onErrorJustReturn: GithubError(object: GithubRawError.init(err: []))))
    }
    
    func output() -> GetUserDetailViewModel.Output {
        return _output
    }
}
