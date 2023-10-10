//
//  BusinessSearchResultsCollectionViewCell.swift
//  FarmersMarketSocialMedia
//
//  Created by Paige Stephenson on 9/8/23.
//

import UIKit

class BusinessSearchResultsCollectionViewCell: UICollectionViewCell {
    
    var onFavorite: (() -> Void)?
    

    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        self.onFavorite?()
    }
    

}
