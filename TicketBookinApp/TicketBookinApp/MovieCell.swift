//
//  MovieCell.swift
//  TicketBookinApp
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 15
            imageView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.textColor = .white
            titleLabel.textAlignment = .left
            titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 15
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .white
//        label.textAlignment = .left
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
////        contentView.addSubview(imageView)
////        contentView.addSubview(titleLabel)
////        
////        // Layout for ImageView
////        NSLayoutConstraint.activate([
////            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
////            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
////            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
////            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.87)
////        ])
////        
////        // Layout for Title Label
////        NSLayoutConstraint.activate([
////            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
////            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
////            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
////            titleLabel.heightAnchor.constraint(equalToConstant: 20)
////        ])
//        
//        // Add border or shadow if needed
//
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func configure(image: UIImage?, title: String) {
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        
        
        imageView.image = image
        titleLabel.text = title
        contentView.backgroundColor = .red
    }
    
}
