//
//  UIView.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/14/23.
//

import UIKit

extension UIView {
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        if layer.mask != nil {
            layer.mask = nil
            superview?.layoutIfNeeded()
        }
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
