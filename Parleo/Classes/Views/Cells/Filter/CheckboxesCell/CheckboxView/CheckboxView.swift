//
//  CheckboxView.swift
//  Parleo
//
//  Created by Alex Azarov on 3/23/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class CheckboxView: UIView, NibLoadable {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var checkboxImageView: UIImageView!

    private var isChecked = false

    init(title: String, isChecked: Bool = false) {
        super.init(frame: .zero)

        loadNibContent()
        titleLabel.text = title
        self.isChecked = isChecked
        updateImageState()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func toggle(_ sender: Any) {
        isChecked.toggle()
        UIView.transition(with: checkboxImageView, duration: 0.2, options: .transitionCrossDissolve, animations: updateImageState, completion: nil)
    }

    private func updateImageState() {
        checkboxImageView.image = isChecked ? R.image.checkbox_on()! : R.image.checkbox_off()!
    }
}
