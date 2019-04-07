//
//  ListOfChatsCell.swift
//  Parleo
//
//  Created by Alex Azarov on 3/30/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import IGListKit

class ListOfChatsCellModel: ListDiffable {

    let dialogTitle: String
    let unreadMessages: Int

    init(dialogTitle: String, unreadMessages: Int) {
        self.unreadMessages = unreadMessages
        self.dialogTitle = dialogTitle
    }

    // MARK: ListDiffable

    func diffIdentifier() -> NSObjectProtocol {
        return dialogTitle as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? ListOfChatsCellModel else { return false }
        return dialogTitle == object.dialogTitle
    }
}

class ListOfChatsCell: UICollectionViewCell {

    @IBOutlet private var unreadMessagesContainerView: UIView!
    @IBOutlet private var unreadMessagesLabel: UILabel!
    @IBOutlet private var dialogTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        unreadMessagesContainerView.layer.cornerRadius = 10
        unreadMessagesContainerView.layer.masksToBounds = true
    }

    func configure(with model: ListOfChatsCellModel) {
        unreadMessagesLabel.text = String(model.unreadMessages)
        dialogTitleLabel.text = model.dialogTitle
    }
}
