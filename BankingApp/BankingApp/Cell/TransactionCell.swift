//
//  TransactionCell.swift
//  BankingApp
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ model: transaction) {
        label.text = model.transaction_label
        amount.text = "\(model.amount) AED \(model.type == .credit ? "🟢" : "🔴")"
        date.text = model.date
        
    }

}
