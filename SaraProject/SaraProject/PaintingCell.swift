//
//  PaintingCell.swift
//  SaraProject
//
//  Created by Bilal Mughal on 13/11/2024.
//

import UIKit

class PaintingCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!{
        didSet{
            cellImage.layer.cornerRadius = 15
            cellImage.layer.masksToBounds = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
