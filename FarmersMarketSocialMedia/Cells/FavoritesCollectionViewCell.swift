//
//  FavoritesCollectionViewCell.swift
//  FarmersMarketSocialMedia
//
//  Created by Paige Stephenson on 9/15/23.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    var onFavorite: (() -> Void)?
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var favoriteButtonTapped: UIButton!
    
    @IBAction func unFavorite(_ sender: UIButton) {
        self.onFavorite?()
    }
}
