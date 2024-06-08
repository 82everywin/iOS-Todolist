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
    
    private var todo: Todo?
    
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
        label.font = UIFont.systemFont(ofSize: 14)
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
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalToSuperview()
        }
        
        todoContainerView.addSubview(todoLabel)
        todoLabel.snp.makeConstraints{ make in
            make.edges.equalTo(todoContainerView).inset(5)
        }
        
    }
    
    func configure(with item: Todo) {
        self.todo = item
        todoLabel.text = item.content
        circleView.layer.borderColor = UIColor(hexCode: item.category.color).cgColor
        circleView.backgroundColor = item.checked ? UIColor(hexCode: item.category.color) : .white
        
        todoLabel.layer.borderColor = UIColor(hexCode: item.category.color).cgColor
        
        let categoryColorHex = item.category.color
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
        
        checkmarkImageView.isHidden = !item.checked
        if item.checked {
               checkmarkImageView.image = UIImage(named: "checkmark") // 여기에 실제 이미지 이름을 넣으세요.
        }
    }
    
    @objc func tapCircleView(_ sender: UITapGestureRecognizer){
        
        circleView.backgroundColor = UIColor(hexCode: (self.todo?.category.color)!)
        checkmarkImageView.image = UIImage(named: "Check_Big")
        checkmarkImageView.isHidden.toggle()
        
//        Task{
//            do {
//                let checkedCircle = try await FetchAPI.shared.updateTodo(todoId: todo?.todoId, todo: self.todo)
//            }
//        }
        
    }
}



//guard let content = categoryName.text, !content.isEmpty  else { return}
//
//Task {
//    do {
//        if selectedCategory != nil {
//            let deletedCategory = try await FetchAPI.shared.deleteCategory(categoryId: categoryId!)
//            print("Category update :\(deletedCategory)")
//        }
//        
//        navigationController?.popViewController(animated: true)
//        
//    }catch {
//        let alert = UIAlertController(title: "Error", message: "Failed to add category", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//        print("Failed to add category: \(error)")
//    }
//}
