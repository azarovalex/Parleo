//
//  OnboardingTextField.swift
//  Parleo
//
//  Created by Alex Azarov on 2/28/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return makePadding(in: bounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return makePadding(in: bounds)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return makePadding(in: bounds)
    }

}

// MARK: - Setup
private extension RoundedTextField {

    func setup() {
        layer.cornerRadius = 25
    }

    func makePadding(in bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
    }
}
