//
//  CategoryCVCell.swift
//  YGGG
//
//  Created by Chung Wussup on 6/5/24.
//

import UIKit

class CategoryCVCell: UICollectionViewCell {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.yggg_gray
        return view
    }()
    
    private let categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
        return iv
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "전체"
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            mainView.backgroundColor = isSelected ? UIColor.yggg_peach : UIColor.yggg_gray
        }
    }
    
    func configureCell(category: TopCategory) {
        categoryImageView.image = UIImage(named: category.imageName)
        categoryLabel.text = category.title
        
        contentView.addSubview(mainView)
        NSLayoutConstraint.activate([
            
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        [categoryImageView, categoryLabel].forEach {
            mainView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            categoryImageView.widthAnchor.constraint(equalToConstant: 18),
            categoryImageView.heightAnchor.constraint(equalToConstant: 21),
            categoryImageView.topAnchor.constraint(equalTo: mainView.topAnchor,
                                                   constant: 9),
            categoryImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor,
                                                       constant: 9)
        ])
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: categoryImageView.trailingAnchor,
                                                   constant: 7),
            categoryLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor,
                                                    constant: -7),
            categoryLabel.centerYAnchor.constraint(equalTo: categoryImageView.centerYAnchor)
        ])
        
        
    }
    
}
