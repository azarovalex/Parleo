//
//  RoundedButton.swift
//  Parleo
//
//  Created by Alex Azarov on 2/28/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
}

// MARK: - Setup
private extension RoundedButton {

    func setup() {
        layer.cornerRadius = 25
    }
}
