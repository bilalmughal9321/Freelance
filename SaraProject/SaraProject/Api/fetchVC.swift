//
//  fetchVC.swift
//  SaraProject
//
//  Created by Bilal Mughal on 26/11/2024.
//

import UIKit

class fetchVC: UIViewController {

    @IBOutlet weak var txtView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    
    @IBAction func fetchApi(_ sender: Any) {
        
        self.startLoading()
        
        NetworkService.shared.fetchData(from: "https://mocki.io/v1/1ec4ab69-31fd-4117-b2f8-361baeef9342") { [weak self] result in
            DispatchQueue.main.async {
                self?.stopLoading()
            }
            
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let items = try decoder.decode([Museum].self, from: data)
                    
                    DispatchQueue.main.async {
                        
                        for value in items {
                            self?.txtView.text.append("Name: \(value.name)\nLocation:  \(value.location)\nestablished:\(value.established)\nFee: \(value.entryFee)\n\n")
                        }
                        
                    }
                    
                    
                } catch {
                    print("JSON Decoding Error: \(error)")
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
