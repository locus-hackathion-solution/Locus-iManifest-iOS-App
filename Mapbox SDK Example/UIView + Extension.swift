//
//  UIView + Extension.swift
//  Home Screen With Top Menu Bar
//
//  Created by Pankaj Kulkarni on 10/05/19.
//  Copyright © 2019 iManifest. All rights reserved.
//

import UIKit

extension UIView {
    func dropShadow(enable: Bool = true) {
        if enable {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.2
            layer.shadowOffset = .zero
            layer.shadowRadius = 2
        } else {
            layer.shadowColor = self.backgroundColor?.cgColor
            layer.shadowOpacity = 0
            layer.shadowRadius = .zero
        }

    }

    func roundTopCorners(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func roundBottomCorners(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    func roundCornersExceptTopLeft(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMaxXMinYCorner,
                                    .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    func roundCornersExceptBottomRight(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                                    .layerMinXMaxYCorner]
    }

    func roundCornersExceptBottomLeft(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                                    .layerMaxXMaxYCorner]
    }
}
