//
//  UnscrolableTableView.swift
//  Parleo
//
//  Created by Artyom Shaiter on 3/8/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class UnscrolableTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override var contentSize: CGSize {
        didSet {
            if oldValue != contentSize  {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    private func initialize() {
        isScrollEnabled = false
    }
}
