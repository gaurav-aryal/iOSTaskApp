//
//  MealTableViewCell.swift
//  AppDevelopmentProject1
//
//  Created by Gaurav Aryal on 2/16/20.
//  Copyright © 2020 Gaurav Aryal. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var datePickerLabel: UILabel!
    //    @IBOutlet weak var photImageView: UIImageView!
    //    @IBOutlet weak var ratingControl: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
