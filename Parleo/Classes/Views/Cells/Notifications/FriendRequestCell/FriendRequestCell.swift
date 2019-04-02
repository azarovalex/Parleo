//
//  FriendRequestCell.swift
//  Parleo
//
//  Created by Alex Azarov on 3/31/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class FriendRequestCell: UITableViewCell {

    @IBOutlet private var friendNameLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var avatarImageView: UIImageView!

    private var acceptAction = { }
    private var declineAction = { }

    func configure(with model: AppNotification, acceptAction: @escaping () -> Void, declineAction: @escaping () -> Void) {
        friendNameLabel.text = model.username
        timeLabel.text = model.timeStamp
        avatarImageView.image = Bool.random() ? R.image.avatar_example()! : R.image.randomGirl()!

        self.acceptAction = acceptAction
        self.declineAction = declineAction
    }

    @IBAction func accept(_ sender: UIButton) {
        acceptAction()
    }

    @IBAction func decline(_ sender: UIButton) {
        declineAction()
    }
}
