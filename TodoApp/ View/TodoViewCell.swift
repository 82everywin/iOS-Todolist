//
//  TodoViewCell.swift
//  TodoApp
//
//  Created by 한현승 on 5/26/24.
//

import Foundation
import UIKit
import SnapKit

final class TodoViewCell: UICollectionViewCell {
    
    private let circleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 13
        view.backgroundColor = .white
        return view
    }()
    
    private let todoLabel: CustomLabel = {
        let label = CustomLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.labelFontColor
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return label
    }()
    
    private let todoContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpViews() {
        contentView.addSubview(circleView)
        self.circleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(26)
        }
        
        contentView.addSubview(todoContainerView)
        self.todoContainerView.snp.makeConstraints{ make in
            make.leading.equalTo(circleView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalToSuperview()
        }
        
        todoContainerView.addSubview(todoLabel)
        todoLabel.snp.makeConstraints{ make in
            make.edges.equalTo(todoContainerView).inset(5)
        }
        
    }
    
    func configure(with item: Todo) {
        todoLabel.text = item.content
        circleView.layer.borderColor = UIColor(hexCode: item.category.color).cgColor
        circleView.backgroundColor = item.checked ? UIColor(hexCode: item.category.color) : .white
        
        todoLabel.layer.borderColor = UIColor(hexCode: item.category.color).cgColor
        
        let categoryColorHex = item.category.color
        print(categoryColorHex)
        switch categoryColorHex {
        case "F9B0CA":
            todoLabel.backgroundColor = UIColor.thinPink
        case "47D2CA" :
            todoLabel.backgroundColor = UIColor.thinGreen
        case "FFDC60" :
            todoLabel.backgroundColor = UIColor.thinYellow
        case "B6B0F9" :
            todoLabel.backgroundColor = UIColor.thinPurple
        default:
            todoLabel.backgroundColor = UIColor.white
        }
        
        print("color \(UIColor(hexCode: item.category.color) ) &&&&& \(todoLabel.backgroundColor)")
//        todoLabel.backgroundColor = UIColor.white
    }
}

