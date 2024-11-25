//
//  HistoryCell.swift
//  TicketBookinApp
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var ContentView: UIView!{
        didSet{
            ContentView.layer.cornerRadius = 20
            ContentView.layer.masksToBounds = true
            ContentView.layer.borderWidth = 1
            ContentView.layer.borderColor = UIColor(red: 223/255, green: 186/255, blue: 57/255, alpha: 1).cgColor
            
        }
        
        
//        223,186,57
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
