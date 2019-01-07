//
//  GetRepositoryViewModel.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class GetRepositoryViewModel {
    
    struct Input {
        var username: Observable<String>
    }
    
    struct Output {
        var isLoading: Driver<Bool>
        var repositories: Driver<[Repository]>
        var failed: Driver<GithubError>
    }
    
    // MARK: - Properties
    
    // Viewから受け取るトリガー
    private var _input: GetRepositoryViewModel.Input!
    // Viewにデータをバインドする
    private var _output: GetRepositoryViewModel.Output!
    // GithubAPIからユーザのリポジトリ一覧を取得するModel
    private let getRepositoryViewModel = GetRepositoryModel()
    
    // MARK: - Init
    
    init(trigger: GetRepositoryViewModel.Input) {
        
        _input = trigger
        
        getRepositoryViewModel.rx_get(from: _input.username)
        
        _output = GetRepositoryViewModel.Output.init(
            isLoading:getRepositoryViewModel.status().isLoading
                .asDriver(onErrorJustReturn: false),
            repositories: getRepositoryViewModel.status().success
                .asDriver(onErrorJustReturn:[]),
            failed: getRepositoryViewModel.status().failed
                .asDriver(onErrorJustReturn: GithubError(object: GithubRawError.init(err: []))))
    }
    
    func output() -> GetRepositoryViewModel.Output {
        return _output
    }
}
