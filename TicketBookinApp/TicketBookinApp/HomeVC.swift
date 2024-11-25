//
//  HomeVC.swift
//  TicketBookinApp
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit

struct Movies {
    var name: String
    var image: UIImage?
    var detail: String
    var selelctedData: Date?
    var isBooked: Bool = false
}

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
//    private var collectionView: UICollectionView!
    
    var movies: [Movies] = [
        Movies(
            name: "Avatar",
            image: UIImage(named: "avatar"),
            detail: "a paraplegic Marine named Jake Sully (Sam Worthington) replacing his deceased identical twin brother in a program to explore the moon Pandora",
            selelctedData: nil,
            isBooked: false),
        
        Movies(
            name: "Inception",
            image: UIImage(named: "inception"),
            detail: "Dom Cobb and Arthur are 'extractors' who perform corporate espionage using experimental dream-sharing technology to infiltrate their targets' subconscious and extract information. Their latest target, Saito, is impressed with Cobb's ability to layer multiple dreams within each other",
            selelctedData: nil,
            isBooked: false),
        
        Movies(
            name: "Titanic",
            image: UIImage(named: "titanic"),
            detail: "In 1912, 17-year-old Rose DeWitt Bukater boards the Titanic in Southampton with her wealthy fiancé, Cal Hockley, and her mother, Ruth. Ruth stresses that Rose's marriage to Cal will resolve their financial problems, but Rose is unhappy in the loveless engagement",
            selelctedData: nil,
            isBooked: false),
        
        Movies(
            name: "Interstellar",
            image: UIImage(named: "interstellar"),
            detail: "In the mid-21st century, humanity faces extinction due to widespread crop blights and dust storms. Joseph Cooper, a widowed former NASA test pilot",
            selelctedData: nil,
            isBooked: false),
        
        Movies(
            name: "Dark Knight",
            image: UIImage(named: "dark_knight"),
            detail: "The Dark Knight is a 2008 superhero film directed by Christopher Nolan, from a screenplay co-written with his brother Jonathan. Based on the DC Comics superhero Batman",
            selelctedData: nil,
            isBooked: false),
        
        Movies(
            name: "Avengers",
            image: UIImage(named: "avengers"),
            detail: "In 2018, 23 days after Thanos erased half of all life in the universe,[a] Carol Danvers rescues Tony Stark and Nebula from deep space and assembles a team of Avengers to stop Thanos from destroying all of reality.",
            selelctedData: nil,
            isBooked: false)
    ]
    
//    private let movies = [
//        ("Avatar", UIImage(named: "avatar")),
//        ("Inception", UIImage(named: "inception")),
//        ("Titanic", UIImage(named: "titanic")),
//        ("Interstellar", UIImage(named: "interstellar")),
//        ("Dark Knight", UIImage(named: "dark_knight")),
//        ("Avengers", UIImage(named: "avengers"))
//    ]
    
    var filteredMovies: [Movies] = []
    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"
        
        setupCollectionView()
        setupSearchController()
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        self.view.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 39/255, alpha: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            if let indexPath = sender as? IndexPath {
                let destinationVC = segue.destination as! DetailVC
                destinationVC.selectMovie = movies[indexPath.row]
            }

        }
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        
        // Customize the search bar appearance
        searchController.searchBar.barStyle = .default
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.textColor = .black
        searchController.searchBar.tintColor = .white // Cursor and cancel button color
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupCollectionView() {
        // Define the layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // Vertical scrolling
        layout.minimumLineSpacing = 15 // Spacing between rows
        layout.minimumInteritemSpacing = 15 // Spacing between items in a row
        
        // Initialize the collection view
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
  
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltering ? filteredMovies.count : movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! MovieCell
        let item = isFiltering ? filteredMovies[indexPath.item] : movies[indexPath.item]
        cell.configure(image: item.image, title: item.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: indexPath)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate width for 2 items per row with spacing
        let padding: CGFloat = 15 // Spacing between cells
        let availableWidth = collectionView.frame.width - padding
        let itemWidth = availableWidth / 2
        return CGSize(width: itemWidth, height: 300)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredMovies = []
            collectionView.reloadData()
            return
        }
        
        filteredMovies = movies.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        collectionView.reloadData()
    }
    
    // Helper to check if we are filtering
    var isFiltering: Bool {
        return !searchController.searchBar.text!.isEmpty
    }
}
