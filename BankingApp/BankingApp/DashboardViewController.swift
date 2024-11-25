//
//  DashboardViewController.swift
//  BankingApp
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit

class DashboardViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        title = "Dashboard"
        let viewTransactionsButton = UIButton(type: .system)
        viewTransactionsButton.setTitle("View Transactions", for: .normal)
        viewTransactionsButton.addTarget(self, action: #selector(showTransactions), for: .touchUpInside)

        let sendMoneyButton = UIButton(type: .system)
        sendMoneyButton.setTitle("Send Money", for: .normal)
        sendMoneyButton.addTarget(self, action: #selector(showSendMoney), for: .touchUpInside)

        let profileButton = UIButton(type: .system)
        profileButton.setTitle("Profile", for: .normal)
        profileButton.addTarget(self, action: #selector(showProfile), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [viewTransactionsButton, sendMoneyButton, profileButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func showTransactions() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let dashboardVC = sb.instantiateViewController(withIdentifier: "TransactionHistoryViewController") as? TransactionHistoryViewController {
            navigationController?.pushViewController(dashboardVC, animated: true)
        }
//        let transactionVC = TransactionHistoryViewController()
//        navigationController?.pushViewController(transactionVC, animated: true)
    }

    @objc private func showSendMoney() {
//        let sendMoneyVC = SendMoneyViewController()
//        navigationController?.pushViewController(sendMoneyVC, animated: true)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let dashboardVC = sb.instantiateViewController(withIdentifier: "SendMoneyViewController") as? SendMoneyViewController {
            navigationController?.pushViewController(dashboardVC, animated: true)
        }
    }

    @objc private func showProfile() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

