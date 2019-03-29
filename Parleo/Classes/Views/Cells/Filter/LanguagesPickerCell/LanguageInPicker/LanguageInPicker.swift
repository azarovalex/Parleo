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


    init() {
        super.init(frame: .zero)

        loadNibContent()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
