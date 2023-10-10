//
//  BusinessProfileTableViewCell.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 9/29/23.
//

import UIKit

class BusinessListingPostCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var postImage: UIImageView!

    var withImageConstraints: [NSLayoutConstraint] = []
    var withoutImageConstraints: [NSLayoutConstraint] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        postImage.contentMode = .scaleAspectFit
    }
    
    func setupConstraints() {
        // Disable autoresizing for these views
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        postImage.translatesAutoresizingMaskIntoConstraints = false

        // Constraints when the image is present
        withImageConstraints = [
            // dateLabel constraints
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8), // 8 as padding, can be adjusted
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),

            // descriptionLabel constraints
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            // postImage constraints
            postImage.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImage.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            postImage.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, multiplier: 0.5),
            postImage.widthAnchor.constraint(equalTo: postImage.heightAnchor, multiplier: postImage.image!.size.width / postImage.image!.size.height)
        ]

       
        // Constraints when the image is absent
        withoutImageConstraints = [
            // dateLabel constraints
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8), // 8 as padding, can be adjusted
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),

            // descriptionLabel constraints
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ]

        // Activate the constraints for when the image is present by default
        NSLayoutConstraint.activate(withImageConstraints)
    }
    
    func toggleConstraintsForImage(present: Bool) {
        if present {
            NSLayoutConstraint.deactivate(withoutImageConstraints)
            NSLayoutConstraint.activate(withImageConstraints)
        } else {
            NSLayoutConstraint.deactivate(withImageConstraints)
            NSLayoutConstraint.activate(withoutImageConstraints)
        }
        layoutIfNeeded() // Force an immediate layout pass
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        toggleConstraintsForImage(present: true) // Reset to default state (assuming image is there by default)
    }
}
