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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
     //   setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
     //   setupViews()
        setupConstraints()
    }

//    func setupViews() {
//        // Here, add your views (if they're not added via storyboard) and set properties like number of lines, content modes, etc.
//        descriptionLabel.numberOfLines = 0
//        descriptionLabel.lineBreakMode = .byWordWrapping
//        postImage.contentMode = .scaleAspectFit
//    }
    

    func setupConstraints() {
        // Your constraints code goes here
    }

}
