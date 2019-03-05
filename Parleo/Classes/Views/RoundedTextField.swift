//
//  OnboardingTextField.swift
//  Parleo
//
//  Created by Alex Azarov on 2/28/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {

    private enum Constants {
        static let padding: CGFloat = 20
        static let cornerRadius = 25
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).insetBy(dx: Constants.padding, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds).insetBy(dx: Constants.padding, dy: 0)
    }
}

// MARK: - Setup
private extension RoundedTextField {

    func setup() {
        layer.cornerRadius = 25
    }
}
