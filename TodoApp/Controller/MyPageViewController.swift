//
//  MyPageViewController.swift
//  TodoApp
//
//  Created by 한현승 on 6/4/24.
//

import UIKit
import SnapKit


class MyPageViewController: UIViewController {
    
    private let mainView: UIView = {
        let view =  UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
        view.layer.borderColor = UIColor.lineColor.cgColor
        view.layer.shadowColor = UIColor(hexCode: "EAEAEA").cgColor
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 2, height: 5)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 5
        return view
    }()
    
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요. 김사랑님!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let logoutBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("로그아웃", for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.backgroundColor = UIColor(hexCode: "EEF3FF").cgColor
        btn.setTitleColor(  UIColor(hexCode: "4260FF"), for: .normal)
        return btn
    }()
    
    private let changePwBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("비밀번호 변경", for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.backgroundColor = UIColor(hexCode: "EEF3FF").cgColor
        btn.setTitleColor(  UIColor(hexCode: "4260FF"), for: .normal)
        return btn
    }()
    
    private let deleteAccountBtn: UIButton = {
           let btn = UIButton()
           btn.setTitle("탈퇴하기", for: .normal)
           btn.layer.backgroundColor = UIColor(hexCode: "EEF3FF").cgColor
           btn.setTitleColor(UIColor(hexCode: "4260FF"), for: .normal)
           btn.layer.cornerRadius = 10
           return btn
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "마이페이지"
        self.view.backgroundColor = .white
        
        logoutBtn.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        changePwBtn.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        deleteAccountBtn.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
      private func setUpViews() {
          self.view.addSubview(mainView)
          mainView.addSubview(profileImageView)
          mainView.addSubview(nameLabel)
          mainView.addSubview(logoutBtn)
          mainView.addSubview(changePwBtn)
          self.view.addSubview(deleteAccountBtn)
          
          mainView.snp.makeConstraints { make in
              make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
              make.leading.equalTo(view).offset(20)
              make.trailing.equalTo(view).offset(-20)
              make.height.equalTo(400)
          }
          
          profileImageView.snp.makeConstraints { make in
              make.top.equalTo(mainView).offset(40)
              make.centerX.equalTo(mainView)
              make.width.height.equalTo(150)
          }
          
          nameLabel.snp.makeConstraints { make in
              make.top.equalTo(profileImageView.snp.bottom).offset(20)
              make.centerX.equalToSuperview()
          }
          
          logoutBtn.snp.makeConstraints { make in
              make.top.equalTo(nameLabel.snp.bottom).offset(50)
              make.leading.equalTo(mainView).offset(10)
              make.trailing.equalTo(mainView.snp.centerX).offset(-1)
              make.height.equalTo(50)
          }
          
          changePwBtn.snp.makeConstraints { make in
              make.top.equalTo(nameLabel.snp.bottom).offset(50)
              make.leading.equalTo(mainView.snp.centerX).offset(1)
              make.trailing.equalTo(mainView).offset(-10)
              make.height.equalTo(50)
          }
          
          deleteAccountBtn.snp.makeConstraints { make in
              make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
              make.centerX.equalTo(mainView)
              make.width.equalTo(110)
              make.height.equalTo(45)
          }
          
    }
    
    @objc private func logoutButtonTapped() {
     
        print("Logout button tapped")
    }
    
    @objc private func changePasswordButtonTapped() {
        print("Change password button tapped")
    }
    
    @objc private func deleteAccountButtonTapped() {
        
        print("Delete account button tapped")
    }
}
