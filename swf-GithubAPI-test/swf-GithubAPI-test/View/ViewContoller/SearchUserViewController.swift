//
//  SearchUserViewController.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

final class SearchUserViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var userSearchTableView: UITableView!
    
    // MARK: - Properties
    
    private let searchUserDataSource = SearchUserDataSource()
    private let disposeBag = DisposeBag()
    // ユーザ検索
    private var searchUserViewModel: SearchUserViewModel!
    private var userSearchBarObservable: Observable<String> {
        return userSearchBar.rx.text
            .filter { $0 != nil}
            .map { $0! }
            .filter { $0.count > 0}
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    // ユーザ詳細
    private var getUserDetailViewModel: GetUserDetailViewModel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupViewModel()
        
        bindToSearchUserViewModel()
        bindToGetUserDetailViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = userSearchTableView.indexPathForSelectedRow {
            userSearchTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
}

// MARK: - Class Extension
extension SearchUserViewController {
    
    private func setupTableView() {
        
        userSearchTableView.dataSource = searchUserDataSource
        
        let nib = UINib(nibName: "ListUserTableViewCell", bundle: nil)
        userSearchTableView.register(nib, forCellReuseIdentifier: "ListUserTableViewCell")
        
        userSearchTableView.estimatedRowHeight = 104
        userSearchTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupViewModel() {
        
        // ユーザ検索
        let searchUserInput = SearchUserViewModel.Input.init(keyword: userSearchBarObservable)
        searchUserViewModel = SearchUserViewModel(trigger: searchUserInput)
        
        // ユーザ詳細
        let detaiUserInput = GetUserDetailViewModel
            .Input.init(
                username: userSearchTableView.rx
                    .modelSelected(ListUser.self)
                    .map { $0.userName ?? "" })
        getUserDetailViewModel = GetUserDetailViewModel(trigger: detaiUserInput)
    }
    
    private func bindToSearchUserViewModel() {
        
        let searchUserOutput = searchUserViewModel.output()
        
        // 読み込み中
        searchUserOutput.isLoading
            .drive(onNext: { [weak self] isLoading in
                guard let weakSelf = self else { return }
                weakSelf.userSearchBar.resignFirstResponder()
                if isLoading {
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            })
            .disposed(by: disposeBag)
        
        // ユーザ一覧の連携
        searchUserOutput.userList
            .drive(userSearchTableView.rx.items(dataSource: searchUserDataSource))
            .disposed(by: disposeBag)
        
        // TableViewの表示・非表示
        searchUserOutput.userList
            .map { $0.count <= 0 }
            .drive(userSearchTableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        // エラー発生時
        searchUserOutput.failed
            .drive(onNext: { [weak self] err in
                guard let weakSelf = self else { return }
                guard let err = err.err, !err.isEmpty else {
                    return }
                let alert = UIAlertController(title: "該当するユーザは見つかりませんでした。\nキーワードを変えて検索してください。",
                                              message: "",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                //ポップアップを閉じる
                if weakSelf.navigationController?.visibleViewController is UIAlertController != true {
                    weakSelf.present(alert, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindToGetUserDetailViewModel() {
        
        let detailUserOutput = getUserDetailViewModel.output()
        
        // 読み込み中
        detailUserOutput.isLoading
            .drive(onNext: { isLoading in
                if isLoading {
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            })
            .disposed(by: disposeBag)
        
        // ユーザリポジトリ画面に遷移
        detailUserOutput.detailUser
            .drive(onNext: { [weak self] user in
                let storyboard = UIStoryboard(name: "UserRepositoryViewController", bundle: nil)
                guard let weakSelf = self,
                    let userRepoVC = storyboard.instantiateInitialViewController() as? UserRepositoryViewController
                    else { return }
                userRepoVC.detailUser = user
                weakSelf.navigationController?.pushViewController(userRepoVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // エラー発生時
        detailUserOutput.failed
            .drive(onNext: { [weak self] err in
                guard let weakSelf = self else { return }
                guard let err = err.err, !err.isEmpty else {
                    return }
                let alert = UIAlertController(title: "データの取得に失敗しました。\n時間をおいて再度お試しください。",
                                              message: "",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                //ポップアップを閉じる
                if weakSelf.navigationController?.visibleViewController is UIAlertController != true {
                    weakSelf.present(alert, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
}
