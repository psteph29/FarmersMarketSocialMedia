//
//  BubbleView.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 10/8/23.
//

import Foundation
import UIKit

class BubbleView: UIView {
    
    private let messageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        messageLabel.text = "Tap the address for directions!"
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 12)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(messageLabel)
        
        // Set up constraints for the label
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -8)
        ])
    }
}
