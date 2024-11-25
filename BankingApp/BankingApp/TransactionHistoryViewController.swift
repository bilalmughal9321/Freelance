//
//  TransactionHistoryViewController.swift
//  BankingApp
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit

enum incomeWay {
    case debit
    case credit
}

struct transaction {
    
    var transaction_label: String
    var amount: String
    var type: incomeWay
    var date: String
    
}

class TransactionHistoryViewController: UIViewController {
    @IBOutlet weak var screenTable: UITableView!
    
    static var data: [transaction] = [
        transaction(transaction_label: "Electric Bill Payment", amount: "1000", type: .debit, date: "24 Nov, 2024"),
        transaction(transaction_label: "Money Received from Ali", amount: "1500", type: .credit, date: "15 Nov, 2024"),
        transaction(transaction_label: "Money Sent to Abdullah", amount: "2000", type: .credit, date: "20 Nov, 2024")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenTable.delegate = self
        screenTable.dataSource = self
        screenTable.separatorStyle = .none
        
        self.title = "Transaction History"
//        view.backgroundColor = .white
//        title = "Transaction History"
//
//        let label = UILabel()
//        label.text = "List of transactions goes here."
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(label)
//
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
    }
}

extension TransactionHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TransactionHistoryViewController.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TransactionCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        cell.configure(TransactionHistoryViewController.data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
