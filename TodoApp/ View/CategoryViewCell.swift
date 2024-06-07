//
//  CategoryCell.swift
//  TodoApp
//
//  Created by 한현승 on 5/26/24.
//

import Foundation
import UIKit


class CategoryViewCell: UICollectionViewCell {
    
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.layer.cornerRadius = 30
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
        
    func configure(with category: CategoryResponse) {
        label.text = category.content
        contentView.layer.borderColor = UIColor(hexCode: category.color).cgColor
        
        let categoryColorHex = category.color
        switch categoryColorHex {
        case "F9B0CA":
            contentView.layer.backgroundColor = UIColor.thinPink.cgColor
        case "47D2CA" :
            contentView.layer.backgroundColor = UIColor.thinGreen.cgColor
        case "FFDC60" :
            contentView.layer.backgroundColor = UIColor.thinYellow.cgColor
        case "B6B0F9" :
            contentView.layer.backgroundColor = UIColor.thinPurple.cgColor
        default:
            contentView.layer.backgroundColor = UIColor.white.cgColor
        }
    }
}
