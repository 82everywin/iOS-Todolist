//
//  MyPageViewController.swift
//  TodoApp
//
//  Created by 한현승 on 6/4/24.
//

import UIKit
import SnapKit


class MyPageViewController: UIViewController {

    var accToken: String
    var memberName: String?
    
    init(accToken: String){
        self.accToken = accToken
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 13
        view.layer.masksToBounds = false
        return view
    }()

    private let mainView: UIView = {
        let view =  UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
        view.layer.borderColor = UIColor.lineColor.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameFirstLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요."
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(hexCode: "232323")
        label.clipsToBounds = true
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor(hexCode: "232323")
        label.clipsToBounds = true
        return label
    }()
    
    private let nameLastLabel: UILabel = {
        let label = UILabel()
        label.text = "님!"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(hexCode: "232323")
        return label
    }()
    
    private let logoutBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("로그아웃", for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.backgroundColor = UIColor(hexCode: "EEF3FF").cgColor
        btn.setTitleColor(  UIColor(hexCode: "4260FF"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16 )
        btn.clipsToBounds = true
        return btn
    }()
    
    private let changePwBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("비밀번호 변경", for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.backgroundColor = UIColor(hexCode: "EEF3FF").cgColor
        btn.setTitleColor(  UIColor(hexCode: "4260FF"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16 )
        return btn
    }()
    
    private let deleteAccountBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("탈퇴하기", for: .normal)
        btn.layer.backgroundColor = UIColor(hexCode: "EEF3FF").cgColor
        btn.setTitleColor(UIColor(hexCode: "4260FF"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14 )
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
        getMember()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    private func getMember() {
        Task{
            do{
                let member = try await TokenAPI.shared.getMember()
                nameLabel.text = member.userId
            }
        }
        
    }
    
    private func setUpViews() {
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(400)
        }
        
        containerView.addSubview(mainView)
          mainView.snp.makeConstraints { make in
              make.edges.equalTo(containerView)
          }
        
          mainView.addSubview(profileImageView)
          profileImageView.snp.makeConstraints { make in
              make.top.equalTo(mainView).offset(60)
              make.centerX.equalTo(mainView)
              make.width.height.equalTo(160)
          }
          
          mainView.addSubview(nameFirstLabel)
          nameFirstLabel.snp.makeConstraints{ make in
              make.top.equalTo(profileImageView.snp.bottom).offset(30)
              make.leading.equalTo(mainView.snp.centerX).offset(-80)
          }
          
          mainView.addSubview(nameLabel)
          nameLabel.snp.makeConstraints { make in
              make.top.equalTo(profileImageView.snp.bottom).offset(28)
              make.leading.equalTo(mainView.snp.centerX).offset(5)
          }
          
          mainView.addSubview(nameLastLabel)
          nameLastLabel.snp.makeConstraints{ make in
              make.top.equalTo(profileImageView.snp.bottom).offset(30)
              make.leading.equalTo(nameLabel.snp.trailing)
          }
          
          mainView.addSubview(logoutBtn)
          logoutBtn.snp.makeConstraints { make in
              make.top.equalTo(nameLabel.snp.bottom).offset(50)
              make.leading.equalTo(mainView).offset(13)
              make.trailing.equalTo(mainView.snp.centerX).offset(-0.3)
              make.height.equalTo(55)
          }
          mainView.addSubview(changePwBtn)
          changePwBtn.snp.makeConstraints { make in
              make.top.equalTo(nameLabel.snp.bottom).offset(50)
              make.leading.equalTo(mainView.snp.centerX).offset(0.3)
              make.trailing.equalTo(mainView).offset(-13)
              make.height.equalTo(55)
          }
          
          self.view.addSubview(deleteAccountBtn)
          deleteAccountBtn.snp.makeConstraints { make in
              make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
              make.centerX.equalTo(mainView)
              make.width.equalTo(100)
              make.height.equalTo(40)
          }
      
}
    
    @objc private func logoutButtonTapped() {
        let mainVC = MainViewController()
        navigationController?.pushViewController(mainVC, animated: true)
        print("Logout button tapped")
    }
    
    @objc private func changePasswordButtonTapped() {
        print("Change password button tapped")
    }
    
    @objc private func deleteAccountButtonTapped() {
        let alertVC = DeleteMemberViewController(userName: nameLabel.text!)
        alertVC.modalPresentationStyle = .overFullScreen
        self.present(alertVC, animated: false, completion: nil)  
    }
    
}
