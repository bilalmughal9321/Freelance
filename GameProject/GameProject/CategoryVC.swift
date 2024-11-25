//
//  CategoryVC.swift
//  GameProject
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit

class CategoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let categories = ["Math", "General Knowledge", "Science"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Category"
        view.backgroundColor = .white
      
    }

    private func setupTableView() {
       
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "QuizVC") as? QuizVC {
            vc.selectedCategory = categories[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
