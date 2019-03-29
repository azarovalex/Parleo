//
//  LanguageInPicker.swift
//  Parleo
//
//  Created by Alex Azarov on 3/29/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class LanguageInPicker: UIView, NibLoadable {

    @IBOutlet private var languageLogo: UIImageView!
    @IBOutlet private var languageTitleLabel: UILabel!

    private var removeAction = { }

    init(removeAction: @escaping () -> Void) {
        super.init(frame: .zero)

        loadNibContent()
        self.removeAction = removeAction
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func deleteCell(_ sender: Any) {
        removeFromSuperview()
        removeAction()
    }
}
