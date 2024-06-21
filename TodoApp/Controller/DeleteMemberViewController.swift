//
//  DeleteMemberViewController.swift
//  TodoApp
//
//  Created by 한현승 on 6/20/24.
//

import Foundation
import UIKit
import SnapKit

class DeleteMemberViewController: UIViewController{
    
    var userName: String
    
    init(userName: String){
        self.userName = userName
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
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "정말 계정을 삭제하실건가요?"
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    private let imageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "Bomb")
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
        button.setTitle("탈퇴하기", for: .normal)
        button.setTitleColor(UIColor(hexCode:"FF3E3E"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16 )
        return button
    }()
    
    private let buttonSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "F1F1F1")
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
        
        nameLabel.text = userName + "님"
        
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
            make.height.equalTo(340)
        }
        
        containerView.addSubview(alertView)
        alertView.snp.makeConstraints{ make in
            make.edges.equalTo(containerView)
        }
        
        alertView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints{ make in
            make.top.equalTo(alertView.snp.top).offset(45)
            make.centerX.equalTo(alertView.snp.centerX)
            make.width.equalTo(100)
        }
        
        alertView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints{make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.centerX.equalTo(alertView.snp.centerX)
            make.width.equalTo(200)
        }
        
        alertView.addSubview(imageView)
        imageView.snp.makeConstraints{ make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.leading.equalTo(alertView.snp.leading).offset(50)
            make.trailing.equalTo(alertView.snp.trailing).offset(-50)
        }
        
        alertView.addSubview(buttonSeparator)
        buttonSeparator.snp.makeConstraints{ make in
            make.top.equalTo(alertView.snp.bottom).offset(-70)
            make.bottom.equalTo(alertView.snp.bottom).offset(-69)
            make.width.equalTo(alertView)
        }
        
        alertView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints{ make in
            make.top.equalTo(alertView.snp.bottom).offset(-70)
            make.leading.equalTo(alertView)
            make.trailing.equalTo(alertView.snp.centerX)
            make.bottom.equalTo(alertView)
        }
        
        alertView.addSubview(buttonline)
        buttonline.snp.makeConstraints{ make in
            make.top.equalTo(alertView.snp.bottom).offset(-55)
            make.leading.equalTo(alertView.snp.centerX).offset(-0.5)
            make.trailing.equalTo(alertView.snp.centerX).offset(0.5)
            make.bottom.equalTo(alertView.snp.bottom).offset(-15)
        }
        
        alertView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints{ make in
            make.top.equalTo(alertView.snp.bottom).offset(-70)
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
                let result = try await TokenAPI.shared.deleteMember()
                print("Successed Delete Member : \(result)")
            }catch {
                print("Failed Delete Member")
            }
        }
        let mainVC = MainViewController()
        navigationController?.pushViewController(mainVC, animated: true)
        
    }
}
