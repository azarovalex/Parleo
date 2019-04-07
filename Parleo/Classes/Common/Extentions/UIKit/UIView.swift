//
//  UIView.swift
//  Parleo
//
//  Created by Artyom Shaiter on 3/4/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

// MARK: UIView+NSLayoutConstraint
public extension UIView {
    func addToView(_ containerView: UIView, top: CGFloat? = 0, bottom: CGFloat? = 0, left: CGFloat? = 0, right: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(self)
        
        if let top = top {
            topAnchor.constraint(equalTo: containerView.topAnchor, constant: top).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: bottom).isActive = true
        }
        if let leading = left {
            leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leading).isActive = true
        }
        if let trailing = right {
            trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: trailing).isActive = true
        }
    }
    
    func constraint(height: CGFloat? = nil, width: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    func constraintToSuperview(centerVertically: CGFloat? = nil, centerHorizontally: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        guard let superview = superview else {
            assertionFailure("View did'h have superview for X and Y axis constraint")
            return
        }
        
        if let centerX = centerHorizontally {
            centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: centerX).isActive = true
        }
        if let centerY = centerVertically {
            centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: centerY).isActive = true
        }
    }
    
    func constraintToView(_ view: UIView, equalWidth: Bool, equalHeight: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if equalWidth {
            widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        }
        if equalHeight {
            heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
        }
    }
    
    func alignConstraintsToView(_ view: UIView, top: CGFloat? = 0, bottom: CGFloat? = 0, left: CGFloat? = 0, right: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        let margin = view.safeAreaLayoutGuide
        if let top = top {
            topAnchor.constraint(equalTo: margin.topAnchor, constant: top).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: bottom).isActive = true
        }
        if let leading = left {
            leadingAnchor.constraint(equalTo: margin.leadingAnchor, constant: leading).isActive = true
        }
        if let trailing = right {
            trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: trailing).isActive = true
        }
    }
    
    func aspectView(height: CGFloat, width: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .width,
                                              multiplier: height / width,
                                              constant: 0))
    }
}

// MARK: UIView+cornerRadius
extension UIView {
    public func roundAllCornersWithMaximumRadius() {
        cornerRadius = min(frame.width, frame.height) / 2.0
    }
    
//    @IBInspectable
//    var cornerRadius: CGFloat {
//        set {
//            layer.cornerRadius = newValue
//            layer.masksToBounds = true
//        }
//        get {
//            return layer.cornerRadius
//        }
//    }
}
