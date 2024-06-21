//
//  ChangePassword.swift
//  TodoApp
//
//  Created by 이예나 on 6/21/24.
//

import Foundation
import UIKit
import SnapKit


class ChangePwViewController: UIViewController {
    // 라벨
    private lazy var pwLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        return label
    }()
    
    private lazy var changePwLabel: UILabel = {
        let label = UILabel()
        label.text = "변경 비밀번호"
        return label
    }()
    
    private lazy var checkPwLabel: UILabel = {
        let label = UILabel()
        label.text = "변경 비밀번호 확인"
        return label
    }()
    
    // 텍스트 필드
    private lazy var idTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.grayBackgroud
        textField.placeholder = " 아이디를 입력해주세요"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.returnKeyType = .next
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        
        textField.addTarget(self, action: #selector(textFieldBlue(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldBasic(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        addLeftPadding(to: textField, image: UIImage(named: "user")!, paddingWidth: 30, paddingHeight: 20)
        
        return textField
    }()
    
    private lazy var pwTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.grayBackgroud
        textField.placeholder =  " 비밀번호를 입력해주세요"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.returnKeyType = .next
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        textField.delegate = self
        
        textField.addTarget(self, action: #selector(textFieldBlue(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldBasic(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        addLeftPadding(to: textField, image: UIImage(named: "Lock")!, paddingWidth: 30, paddingHeight: 20)
        addRightPadding(to: textField, image: UIImage(named: "Eye-closed")!, paddingWidth: 30, paddingHeight: 20, selector: #selector(togglePasswordVisibility(_:)))
        
        return textField
    }()
    
    private lazy var checkpwTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.grayBackgroud
        textField.placeholder = " 비밀번호를 입력해주세요"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.returnKeyType = .next
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        textField.delegate = self
        
        textField.addTarget(self, action: #selector(textFieldBlue(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldBasic(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        addLeftPadding(to: textField, image: UIImage(named: "Lock")!, paddingWidth: 30, paddingHeight: 20)
        addRightPadding(to: textField, image: UIImage(named: "Eye-closed")!, paddingWidth: 30, paddingHeight: 20, selector: #selector(togglePasswordVisibility(_:)))
        
        return textField
    }()
    
    //아이디, 비밀번호 조건
    func isValidUserId(_ userId: String) -> Bool {
        return userId.count >= 5 && userId.count <= 10
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,16}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    // 회원가입 버튼
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("회원가입", for: .normal )
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.MainBackground
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "회원가입"
        self.view.backgroundColor = .white
        
        setupViews()
        updateSignupButtonState()
    }
    
    // 오토레이아웃 설정
    private func setupViews() {
        self.view.addSubview(idLabel)
        self.view.addSubview(idTextField)
        self.view.addSubview(pwLabel)
        self.view.addSubview(pwTextField)
        self.view.addSubview(checkPwLabel)
        self.view.addSubview(checkpwTextField)
        self.view.addSubview(signUpButton)
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalToSuperview().offset(30)
        }
        
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(8)
            make.leading.equalTo(idLabel)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        
        pwLabel.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(20)
            make.leading.equalTo(idLabel)
        }
        
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(pwLabel.snp.bottom).offset(8)
            make.leading.equalTo(pwLabel)
            make.trailing.equalTo(idTextField)
            make.height.equalTo(50)
        }
        
        checkPwLabel.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(20)
            make.leading.equalTo(pwLabel)
        }
        
        checkpwTextField.snp.makeConstraints { make in
            make.top.equalTo(checkPwLabel.snp.bottom).offset(8)
            make.leading.equalTo(checkPwLabel)
            make.trailing.equalTo(pwTextField)
            make.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(checkpwTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
    }
    
    // 모든 필드가 채워져 있는지 확인하는 함수
    private func areFieldsFilled() -> Bool {
        return !(idTextField.text?.isEmpty ?? true) &&
        !(pwTextField.text?.isEmpty ?? true) &&
        !(checkpwTextField.text?.isEmpty ?? true)
    }
    
    // 회원가입 버튼의 상태를 업데이트하는 함수
    private func updateSignupButtonState() {
        if areFieldsFilled() {
            signUpButton.backgroundColor = UIColor.MainBackground
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = UIColor(hexCode: "C1C1C1")
            signUpButton.isEnabled = false
        }
    }
    
    // 텍스트 필드의 편집이 변경될 때마다 회원가입 버튼 상태를 업데이트
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateSignupButtonState()
    }
    
    // 텍스트 필드의 내부 이미지 패딩
    func addLeftPadding(to textField: UITextField, image: UIImage, paddingWidth: CGFloat, paddingHeight: CGFloat) {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingWidth, height: paddingHeight))
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 10, y: 0, width: paddingWidth - 10, height: paddingHeight)
        leftPaddingView.addSubview(imageView)
        
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
    }
    
    // 텍스트 필드의 내부이미지 패딩
    func addRightPadding(to textField: UITextField, image: UIImage, paddingWidth: CGFloat, paddingHeight: CGFloat, selector: Selector) {
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingWidth, height: paddingHeight))
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: -10, y: 0, width: paddingWidth - 10, height: paddingHeight)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
        
        rightPaddingView.addSubview(imageView)
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
    }
    
    // 비밀번호 암호화 처리
    @objc func togglePasswordVisibility(_ sender: UITapGestureRecognizer) {
        pwTextField.isSecureTextEntry.toggle()
        checkpwTextField.isSecureTextEntry.toggle()
    }
    
    // 텍스트 필드 파란 형태
    @objc func textFieldBlue(_ textField: UITextField) {
        textField.backgroundColor = UIColor(hexCode: "#F2F4FF")
        textField.layer.borderColor = UIColor.MainBackground.cgColor
        textField.layer.borderWidth = 1.0
        textField.textColor = UIColor.MainBackground
        
        if textField == idTextField {
            addLeftPadding(to: textField, image: UIImage(named: "userOn")!, paddingWidth: 30, paddingHeight: 20)
        }
    }
    
    // 텍스트 필드 빨간 형태
    @objc func textFieldRed(_ textField: UITextField) {
        textField.backgroundColor = UIColor(hexCode: "#FFF6F6")
        textField.layer.borderColor = UIColor.MainBackground.cgColor
        textField.layer.borderWidth = 1.0
        textField.textColor = UIColor(hexCode: "#FF2121")
        
        if textField == idTextField {
            addLeftPadding(to: textField, image: UIImage(named: "userRed")!, paddingWidth: 30, paddingHeight: 20)
        }
    }
    
    // 텍스트 필드 기본 형태
    @objc func textFieldBasic(_ textField: UITextField) {
        textField.backgroundColor = UIColor.grayBackgroud
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
        textField.textColor = UIColor.black
        
        // Revert left image to original
        if textField == idTextField {
            addLeftPadding(to: textField, image: UIImage(named: "user")!, paddingWidth: 30, paddingHeight: 20)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateSignupButtonState()
    }
    
    // 회원가입 버튼 눌렀을 때 동작 구현
    @objc private func signupButtonTapped() {
        guard let setUserId = idTextField.text,
              let setUserPw = pwTextField.text,
              let setCheckPw = checkpwTextField.text
        else {
            showAlert(message: "양식을 채워주세요")
            return
        }

        // 입력 검증
        if !isValidUserId(setUserId) {
            showAlert(message: "아이디는 5~10자로 입력해주세요.")
            return
        }
        
        if !isValidPassword(setUserPw) {
            showAlert(message: "비밀번호는 8~16자의 영문 대/소문자, 숫자, 특수문자로 입력해주세요.")
            return
        }
        
        if setUserPw != setCheckPw {
            showAlert(message: "비밀번호와 비밀번호 확인이 일치하지 않습니다.")
            return
        }

        Task {
            do {
                // 회원가입 요청
                let newSignup = Signup(userId: setUserId, userPw: setUserPw, confirmUserPw: setCheckPw)
                let signUpData = try await FetchAPI.shared.signUp(data: newSignup)
                print("Signup: \(signUpData)")

                // 회원가입 성공 후 로그인 요청
                let signInData = SignIn(userId: setUserId, userPw: setUserPw)
                let signInResponse = try await FetchAPI.shared.signIn(data: signInData)
                
                // 토큰 저장
                TokenAPI.shared.setToken(signInResponse.token)
                print("Token: \(signInResponse.token)")

                // 로그인 성공 시 메인으로 이동
                let mainVC = MainViewController()
                navigationController?.pushViewController(mainVC, animated: true)
            } catch {
                showAlert(message: "회원가입에 실패하였습니다.")
                print("Failed to SignUp: \(error)")
            }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
