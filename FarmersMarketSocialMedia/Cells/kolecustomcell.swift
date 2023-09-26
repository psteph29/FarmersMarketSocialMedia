//
//  kolecustomcell.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 9/23/23.
//

import UIKit

class kolecustomcell: UICollectionViewCell {

    let businessNameLabel = UILabel()
    let addressLabel = UILabel()
    let backgroundImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Round corners for bubble shape
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        // Add subviews
        contentView.addSubview(backgroundImageView)  // Moved this line up to ensure the image view is at the back
        contentView.addSubview(businessNameLabel)
        contentView.addSubview(addressLabel)
        
        // Enable Auto Layout
        businessNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Styling
        backgroundColor = .clear  // Set to clear, since we're using a background image
        businessNameLabel.font = .boldSystemFont(ofSize: 18)
        addressLabel.font = .systemFont(ofSize: 14)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        // Constraints for backgroundImageView
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Constraints for businessNameLabel
        NSLayoutConstraint.activate([
            businessNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            businessNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            businessNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            businessNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        // Constraints for addressLabel
        NSLayoutConstraint.activate([
            addressLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addressLabel.topAnchor.constraint(equalTo: businessNameLabel.bottomAnchor, constant: 4),  // Adjust constant as needed
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}
