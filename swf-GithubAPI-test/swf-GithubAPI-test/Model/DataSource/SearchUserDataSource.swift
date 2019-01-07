//
//  SearchUserDataSource.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchUserDataSource: NSObject {

    typealias Element = [ListUser]
    
    private var searchResults = [ListUser]()
}

// MARK: - RxTableViewDataSourceType
extension SearchUserDataSource: RxTableViewDataSourceType {
    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        switch observedEvent {
        case .next(let value):
            self.searchResults = value
            tableView.reloadData()
        case .error(_):
            ()
        case .completed:
            ()
        }
    }
}

// MARK: - SectionedViewDataSourceType
extension SearchUserDataSource: SectionedViewDataSourceType {
    
    func model(at indexPath: IndexPath) throws -> Any {
        return searchResults[indexPath.row]
    }
}

// MARK: - UITableViewDataSource
extension SearchUserDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListUserTableViewCell",
                                                       for: indexPath) as? ListUserTableViewCell
            else { return UITableViewCell() }
        cell.configure(listUser: searchResults[indexPath.row])
        return cell
    }
}
