//
//  ListUserTableViewCell.swift
//  swf-GithubAPI-test
//
//  Created by S.Emoto on 2019/01/07.
//  Copyright © 2019 S.Emoto. All rights reserved.
//

import UIKit
import Kingfisher

final class ListUserTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(listUser: ListUser) {
        
        userNameLabel.text = listUser.userName
        guard let iconURL = URL(string: listUser.iconURLStr ?? "")
            else { return }
        userIconImageView.kf.setImage(with: iconURL)
    }
}
