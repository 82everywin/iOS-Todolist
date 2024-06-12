//
//  TodoViewCell.swift
//  TodoApp
//
//  Created by 한현승 on 5/26/24.
//

import Foundation
import UIKit
import SnapKit
import SwiftUI

final class TodoViewCell: UICollectionViewCell {
    
    let circleView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "checkmark.circle")
        return imageView
    }()
    
    

//    private let checkCircleView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.layer.borderWidth = 1
//        view.layer.backgroundColor = UIColor.gray.cgColor
//        view.layer.cornerRadius = 15
//        view.backgroundColor = .white
//        return view
//    }()
    
    private let todoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.layer.backgroundColor = UIColor(hexCode: "FFFFFF").cgColor
        //UIColor(hexCode: "F1F1F1").cgColor
        return label
    }()
    
    private let todoContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
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
        addSubview(circleView)
        self.circleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(35)
        }
        
        addSubview(todoContainerView)
        self.todoContainerView.snp.makeConstraints{ make in
            make.leading.equalTo(circleView.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalToSuperview()
        }
        
        todoContainerView.addSubview(todoLabel)
        todoLabel.snp.makeConstraints{ make in
            make.leading.equalTo(todoContainerView.snp.leading).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(35)
        }
        
    }
    
    func configure(with item: Todo) {
        todoLabel.text = item.content
        circleView.layer.borderColor = UIColor(hexCode: item.category.color).cgColor
        circleView.backgroundColor = item.checked ? UIColor(hexCode: item.category.color) : .white
        }
}
