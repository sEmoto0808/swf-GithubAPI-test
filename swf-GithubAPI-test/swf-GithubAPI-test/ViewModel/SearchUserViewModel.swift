//
//  SearchUserViewModel.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchUserViewModel {
    
    struct Input {
        var keyword: Observable<String>
    }
    
    struct Output {
        var isLoading: Driver<Bool>
        var userList: Driver<[ListUser]>
        var failed: Driver<GithubError>
    }
    
    // MARK: - Properties
    
    // Viewから受け取るトリガー
    private var _input: SearchUserViewModel.Input!
    // Viewにデータをバインドする
    private var _output: SearchUserViewModel.Output!
    // GithubAPIからユーザ一覧を取得するModel
    private let searchUserModel = SearchUserModel()
    
    // MARK: - Init
    
    init(trigger: SearchUserViewModel.Input) {
        
        _input = trigger
        
        searchUserModel.rx_get(from: _input.keyword)
        
        _output = SearchUserViewModel.Output.init(
            isLoading:searchUserModel.status().isLoading
                .asDriver(onErrorJustReturn: false),
            userList: searchUserModel.status().success
                .asDriver(onErrorJustReturn:[]),
            failed: searchUserModel.status().failed
                .asDriver(onErrorJustReturn: GithubError(object: GithubRawError.init(err: []))))
    }
    
    func output() -> SearchUserViewModel.Output {
        return _output
    }
}
