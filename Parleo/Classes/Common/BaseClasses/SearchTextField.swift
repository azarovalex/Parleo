//
//  SearchTextField.swift
//  Parleo
//
//  Created by Artyom Shaiter on 3/31/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        roundAllCornersWithMaximumRadius()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        let leftViewContainer = UIView(frame: Constants.leftViewRect)
        UIImageView(image: R.image.searchIcon()).addToView(leftViewContainer,
                                                           top: Constants.ImageConstraints.top,
                                                           bottom: Constants.ImageConstraints.bottom,
                                                           left: Constants.ImageConstraints.left,
                                                           right: Constants.ImageConstraints.right)
        leftView = leftViewContainer
        leftViewMode = .always
        font = Constants.font
        textColor = R.color.black()?.withAlphaComponent(0.5)
        backgroundColor = R.color.black()?.withAlphaComponent(0.05)
        placeholder = R.string.localizable.commonSearchPlaceholder()
    }
}

private extension SearchTextField {
    enum Constants {
        enum ImageConstraints {
            static let top: CGFloat = 13
            static let bottom: CGFloat = -13
            static let left: CGFloat = 20
            static let right: CGFloat = -8
        }
        
        static let font = R.font.montserratRegular(size: 14)
        static let leftViewRect = CGRect(x: 0, y: 0, width: 46, height: 44)
    }
}
