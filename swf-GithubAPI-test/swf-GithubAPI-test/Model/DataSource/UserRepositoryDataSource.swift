//
//  UserRepositoryDataSource.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class UserRepositoryDataSource: NSObject {

    typealias Element = [Repository]
    
    private var repositoies = [Repository]()
    
}

// MARK: - RxTableViewDataSourceType
extension UserRepositoryDataSource: RxTableViewDataSourceType {
    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        switch observedEvent {
        case .next(let value):
            self.repositoies = value
            tableView.reloadData()
        case .error(_):
            ()
        case .completed:
            ()
        }
    }
}

// MARK: - SectionedViewDataSourceType
extension UserRepositoryDataSource: SectionedViewDataSourceType {
    
    func model(at indexPath: IndexPath) throws -> Any {
        return repositoies[indexPath.row]
    }
}

// MARK: - UITableViewDataSource
extension UserRepositoryDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell",
                                                       for: indexPath) as? RepositoryTableViewCell
            else { return UITableViewCell() }
        cell.configure(repository: repositoies[indexPath.row])
        return cell
    }
}
