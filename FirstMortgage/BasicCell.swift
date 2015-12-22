//
//  BasicCell.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 11/18/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var ratingView: UIImageView!
    
    @IBOutlet weak var bedsLabel: UILabel!
    @IBOutlet weak var bathsLabel: UILabel!
    @IBOutlet weak var sqfeetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}