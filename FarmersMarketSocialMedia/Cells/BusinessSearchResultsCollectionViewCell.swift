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
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    var isFavorited: Bool = false
    
    override func awakeFromNib() {
      super.awakeFromNib()

      // Set initial image
      favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
        favoriteButton.layer.cornerRadius = 10  /*favoriteButton.frame.size.width / 2*/
        favoriteButton.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        onFavorite = nil
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        
        if isFavorited {
          favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
          favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        isFavorited.toggle()
        
        self.onFavorite?()
        
        // animation code
        let totalSegments = 5
        let itemsPerSegment = 2  // or any other number you wish
        
        let shuffledSegments = Array(0..<totalSegments).shuffled()
        
        for (segmentIndex, segment) in shuffledSegments.enumerated() {
            // Shuffle the images and take the first 'itemsPerSegment' items
            let segmentImages = FruitsAndVeggieImages.shuffled().prefix(itemsPerSegment)
            
            for itemIndex in 0..<itemsPerSegment {
                let delay = Double(segmentIndex * itemsPerSegment + itemIndex) * 0.3
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    let fruitOrVeggie = spawnFruitOrVeggie(in: self, segment: segment, totalSegments: totalSegments, itemIndex: itemIndex, shuffledImages: Array(segmentImages))
                    animateFall(of: fruitOrVeggie, in: self)
                }
            }
        }
    }
}
