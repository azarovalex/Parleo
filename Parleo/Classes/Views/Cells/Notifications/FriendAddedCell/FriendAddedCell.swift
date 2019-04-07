//
//  FriendAddedCell.swift
//  Parleo
//
//  Created by Alex Azarov on 3/31/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class FriendAddedCell: UITableViewCell {

    @IBOutlet private var friendNameLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!

    func configure(with model: AppNotification) {
        friendNameLabel.text = model.username
        timeLabel.text = model.timeStamp
    }
}
