//
//  MarketTableViewCell.swift
//  FarmersMarketSocialMedia
//
//  Created by Paige Stephenson on 9/7/23.
//

import UIKit

class MarketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var farmNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with farm: Farm) {
        farmNameLabel.text = farm.listingName
        addressLabel.text = farm.locationAddress
    }

}
