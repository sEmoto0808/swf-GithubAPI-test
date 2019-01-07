//
//  UserRepositoryViewController.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

final class UserRepositoryViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel! {
        didSet {
            userNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followeeCountLabel: UILabel!
    @IBOutlet weak var userRepositoryTableView: UITableView!
    
    // MARK: - Properties
    
    var detailUser: DetailUser!
    
    private let repositoryDataSource = UserRepositoryDataSource()
    private let disposeBag = DisposeBag()
    
    private var getRepositoryViewModel: GetRepositoryViewModel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setupTableView()
        setupViewModel()
        
        bindToRepositoryViewModel()
        
        setRxEventToTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = userRepositoryTableView.indexPathForSelectedRow {
            userRepositoryTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
}

// MARK: - Class Extension
extension UserRepositoryViewController {
    
    private func configure() {
        
        userNameLabel.text = detailUser.userName
        fullNameLabel.text = detailUser.fullName
        followerCountLabel.text = "\(String(describing: detailUser.followerCount ?? 0))"
        followeeCountLabel.text = "\(String(describing: detailUser.followingCount ?? 0))"
        guard let iconURL = URL(string: detailUser.iconURLStr ?? "")
            else { return }
        userIconImageView.kf.setImage(with: iconURL)
        
        title = detailUser.userName
    }
    
    private func setupTableView() {
        
        userRepositoryTableView.dataSource = repositoryDataSource
        
        let nib = UINib(nibName: "RepositoryTableViewCell", bundle: nil)
        userRepositoryTableView.register(nib, forCellReuseIdentifier: "RepositoryTableViewCell")
        
        userRepositoryTableView.estimatedRowHeight = 120
        userRepositoryTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupViewModel() {
        
        let repositoryInput = GetRepositoryViewModel.Input.init(
            username:
            rx.sentMessage(#selector(self.viewWillAppear(_:)))
                .map { [weak self] _ -> String in
                    guard let weakSelf = self else { return "" }
                    return weakSelf.detailUser.userName ?? ""
                }
                .share(replay: 1))
        getRepositoryViewModel = GetRepositoryViewModel(trigger: repositoryInput)
    }
    
    private func bindToRepositoryViewModel() {
        
        let repositoryOutput = getRepositoryViewModel.output()
        
        // 読み込み中
        repositoryOutput.isLoading
            .drive(onNext: { isLoading in
                if isLoading {
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            })
            .disposed(by: disposeBag)
        
        // リポジトリ一覧の連携
        repositoryOutput.repositories
            .drive(userRepositoryTableView.rx.items(dataSource: repositoryDataSource))
            .disposed(by: disposeBag)
        
        // TableViewの表示・非表示
        repositoryOutput.repositories
            .map { $0.count <= 0 }
            .drive(userRepositoryTableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        // エラー発生時
        repositoryOutput.failed
            .drive(onNext: { [weak self] err in
                guard let weakSelf = self else { return }
                guard let err = err.err, !err.isEmpty else {
                    return }
                let alert = UIAlertController(title: "リポジトリは見つかりませんでした。",
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
    
    private func setRxEventToTableView() {
        
        userRepositoryTableView.rx.modelSelected(Repository.self).asDriver()
            .drive(onNext: { [weak self] repository in
                let storyboard = UIStoryboard(name: "RepositoryWebViewController", bundle: nil)
                guard let weakSelf = self,
                    let repoWebVC = storyboard.instantiateInitialViewController() as? RepositoryWebViewController
                    else { return }
                repoWebVC.repositoryURLStr = repository.htmlURLStr ?? ""
                repoWebVC.repositoryName = repository.name ?? ""
                weakSelf.navigationController?.pushViewController(repoWebVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
