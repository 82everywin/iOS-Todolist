//
//  CategoryCell.swift
//  TodoApp
//
//  Created by 한현승 on 5/26/24.
//

import Foundation
import UIKit

final class CategoryViewCell: UICollectionViewCell {
    
    var selectedCategory: CategoryResponse?
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.fontColor
        label.layer.cornerRadius = 15
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(label)
        contentView.layer.cornerRadius = contentView.frame.height / 2
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
           super.layoutSubviews()
           contentView.layer.cornerRadius = contentView.frame.height / 2
    }
        
    func configure(with category: CategoryResponse) {
        label.text = category.content
        contentView.layer.backgroundColor = UIColor(hexCode: category.color).cgColor
        contentView.layer.borderColor = UIColor(hexCode: category.color).cgColor
        
        let categoryColorHex = category.color
        switch categoryColorHex {
        case "F9B0CA":
            contentView.layer.backgroundColor = UIColor.thinPink.cgColor
        case "47D2CA" :
            contentView.layer.backgroundColor = UIColor.thinGreen.cgColor
        case "FFE560" :
            contentView.layer.backgroundColor = UIColor.thinYellow.cgColor
        case "B6B0F9" :
            contentView.layer.backgroundColor = UIColor.thinPurple.cgColor
        default:
            contentView.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
    func choice(with category: CategoryResponse){
        label.text = category.content
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor(hexCode: "D0D0D0").cgColor
    }
        
}
