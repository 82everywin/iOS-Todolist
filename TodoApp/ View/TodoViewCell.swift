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
    
    private var todo: TodoResponse?
    
    private let circleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 13
        view.backgroundColor = .white
        return view
    }()
    
    private let checkmarkImageView: UIImageView = {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFit
          imageView.isHidden = true // 초기에는 숨김 상태
          return imageView
      }()
    
    private let todoLabel: CustomLabel = {
        let label = CustomLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.fontColor
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
        label.textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return label
    }()
    
    private let todoContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
   let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hexCode: "FF3E3E")
        button.isHidden = true
       return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCircleView(_:))) // UIImageView 클릭 제스쳐
        circleView.addGestureRecognizer(tapGesture)
        circleView.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        contentView.addSubview(circleView)
        self.circleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(26)
        }
        
        circleView.addSubview(checkmarkImageView)
        checkmarkImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        contentView.addSubview(todoContainerView)
        self.todoContainerView.snp.makeConstraints{ make in
            make.leading.equalTo(circleView.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalToSuperview()
        }
        
        todoContainerView.addSubview(todoLabel)
        todoLabel.snp.makeConstraints{ make in
            make.edges.equalTo(todoContainerView).inset(5)
        }
        
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(todoContainerView).inset(5)
            make.leading.equalTo(todoContainerView.snp.trailing).offset(1)
            make.width.equalTo(55)
            
        }
    }
    
    func configure(with item: TodoResponse) {
        self.todo = item
        todoLabel.text = item.content
        todoLabel.layer.borderColor = UIColor(hexCode: item.category.color).cgColor
        
        circleView.layer.borderColor = UIColor(hexCode: item.category.color).cgColor
        updateCheckmarkUI(isChecked: item.checked)
        
        let categoryColorHex = item.category.color
        switch categoryColorHex {
        case "F9B0CA":
            todoLabel.backgroundColor = UIColor.thinPink
        case "47D2CA" :
            todoLabel.backgroundColor = UIColor.thinGreen
        case "FFE560" :
            todoLabel.backgroundColor = UIColor.thinYellow
        case "B6B0F9" :
            todoLabel.backgroundColor = UIColor.thinPurple
        default:
            todoLabel.backgroundColor = UIColor.white
        }
        
        deleteButton.isHidden = true
    }
    
    
    @objc func tapCircleView(_ sender: UITapGestureRecognizer){
        guard let todo = todo else { return}
        
        let newCheckedState = !todo.checked
    
        Task{
            do {
                let updateTodo = UpdateTodoRequest(content: todo.content, checked: newCheckedState, setDate: todo.setDate, categoryId: todo.category.categoryId)
                _ = try await TokenAPI.shared.updateTodo(todoId: self.todo!.todoId, todo: updateTodo)
              
                self.todo?.checked = newCheckedState
                updateCheckmarkUI(isChecked: newCheckedState)
            }
            catch{
                let alert = UIAlertController(title: "Error", message: "Failed to update Todo", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                print("Failed to update Todo: \(error)")
            }
        }
    }
    
    private func updateCheckmarkUI(isChecked: Bool){
        checkmarkImageView.isHidden = !isChecked
        circleView.backgroundColor = isChecked ? UIColor(hexCode: (self.todo?.category.color)!) : .white
        if isChecked {
            checkmarkImageView.image = UIImage(named: "Check_Big")
        }
        else {
            checkmarkImageView.image = nil
        }
    }
}


