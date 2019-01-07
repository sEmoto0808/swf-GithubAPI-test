//
//  RepositoryTableViewCell.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import UIKit

final class RepositoryTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet weak var repositoryNameLabel: UILabel! {
        didSet {
            repositoryNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(repository: Repository) {
        
        repositoryNameLabel.text = repository.name
        languageLabel.text = repository.language
        starCountLabel.text = "\(String(describing: repository.starCount ?? 0))"
        descriptionLabel.text = repository.description
    }
}
