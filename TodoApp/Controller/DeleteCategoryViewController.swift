//
//  DeleteCategoryViewController.swift
//  TodoApp
//
//  Created by 한현승 on 6/20/24.
//

import Foundation
import UIKit

class DeleteCategoryViewController: UIViewController {
    
    var accToken: String
    var categoryName: String
    var categroyId: Int
    
    init(accToken: String, categoryId: Int, categoryName: String){
        self.accToken = accToken
        self.categoryName = categoryName
        self.categroyId = categoryId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let containerView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 2, height: 4 )
        view.layer.shadowRadius = 5
        view.layer.masksToBounds = false
        return view
    }()
    
    private let alertView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius  = 15
        view.clipsToBounds = true
        return view
    }()
    
    private let categoryLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 3
        return label
    }()
    
    private let imageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "DeleteCategory")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor(hexCode: "A4A4A4"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16 )
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제하기", for: .normal)
        button.setTitleColor(UIColor(hexCode:"FF3E3E"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16 )
        return button
    }()
    
    private let buttonSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "F1F1F1")
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2 )
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
        return view
    }()
    
    private let buttonline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "F1F1F1")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        categoryLabel.text = "\"\(categoryName)\""
        print(categroyId)
        let attributedMessage = NSMutableAttributedString(string: "카테고리를 삭제하시겠습니까?  이 카테고리로 등록되어있는 \n 할 일이 모두 삭제됩니다.")
       let range1 = (attributedMessage.string as NSString).range(of: " 삭제")
     
       attributedMessage.addAttribute(.foregroundColor, value: UIColor(hexCode: "FF3E3E"), range: range1)
       
        messageLabel.attributedText = attributedMessage
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        setUpViews()
    }
    
    
    private func setUpViews() {
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-60)
            make.height.equalTo(360)
        }
        
        containerView.addSubview(alertView)
        alertView.snp.makeConstraints{ make in
            make.edges.equalTo(containerView)
        }
        
        alertView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints{ make in
            make.top.equalTo(alertView.snp.top).offset(40)
            make.centerX.equalTo(alertView.snp.centerX)
        }
        
        alertView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints{make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(5)
            make.centerX.equalTo(alertView.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(90)
        }
        
        alertView.addSubview(imageView)
        imageView.snp.makeConstraints{ make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.leading.equalTo(alertView.snp.leading).offset(50)
            make.trailing.equalTo(alertView.snp.trailing).offset(-50)
        }
        
        alertView.addSubview(buttonSeparator)
        buttonSeparator.snp.makeConstraints{ make in
            make.top.equalTo(alertView.snp.bottom).offset(-60)
            make.bottom.equalTo(alertView.snp.bottom).offset(-59)
            make.width.equalTo(alertView)
        }
        
        alertView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints{ make in
            make.top.equalTo(alertView.snp.bottom).offset(-60)
            make.leading.equalTo(alertView)
            make.trailing.equalTo(alertView.snp.centerX)
            make.bottom.equalTo(alertView)
        }
        
        alertView.addSubview(buttonline)
        buttonline.snp.makeConstraints{ make in
            make.top.equalTo(alertView.snp.bottom).offset(-50)
            make.leading.equalTo(alertView.snp.centerX).offset(-0.5)
            make.trailing.equalTo(alertView.snp.centerX).offset(0.5)
            make.bottom.equalTo(alertView.snp.bottom).offset(-10)
        }
        
        alertView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints{ make in
            make.top.equalTo(alertView.snp.bottom).offset(-60)
            make.leading.equalTo(alertView.snp.centerX).offset(1)
            make.trailing.equalTo(alertView)
            make.bottom.equalTo(alertView)
        }
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func deleteButtonTapped() {
        Task {
            do{
                let result = try await TokenAPI.shared.deleteCategory(categoryId: categroyId)
                print("Successed Delete Category : \(result)")
               
            }catch {
                print("Failed Delete Member")
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name( "CategoryDeleted"), object: nil)
        self.dismiss(animated: false, completion: nil)
      
    }
}
