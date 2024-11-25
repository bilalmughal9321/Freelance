//
//  HistoryVC.swift
//  TicketBookinApp
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    static var movies: [Movies] = []
    
    @IBOutlet weak var screenTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HistoryVC.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? HistoryCell else { return UITableViewCell() }
        cell.label.text = HistoryVC.movies[indexPath.row].name
        cell.date.text = HistoryVC.movies[indexPath.row].selelctedData?.getString()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }


}


extension Date {
    
    func getString() -> String{
        let currentDate = self

        // Create a DateFormatter
        let dateFormatter = DateFormatter()

        // Set the format you want for the string
        dateFormatter.dateFormat = "dd MMM, yyyy HH:mm"

        // Convert the Date object to a string
        return dateFormatter.string(from: currentDate)
    }
    
}
