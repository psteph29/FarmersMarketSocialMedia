//
//  AnimateFallingFruitVeggie.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 10/8/23.
//

import Foundation
import UIKit

func animateFall(of imageView: UIImageView, in view: UIView) {
    view.addSubview(imageView)

    // Add a rotation animation
    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
    rotationAnimation.duration = 5.0
    rotationAnimation.isCumulative = true
    rotationAnimation.repeatCount = Float.infinity
    imageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    
    // The falling animation
    UIView.animate(withDuration: 2.5, animations: {
        imageView.center.y = view.bounds.height + imageView.bounds.height
    }, completion: { _ in
        imageView.removeFromSuperview()
    })
}
