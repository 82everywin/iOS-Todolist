//
//  ChangePassword.swift
//  TodoApp
//
//  Created by 이예나 on 6/21/24.
//

import Foundation
import UIKit
import SnapKit

class ChangePwViewController: UIViewController, UITextFieldDelegate {
    // 라벨
    private lazy var pwLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 비밀번호"
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
    
    // 비밀번호 입력 필드
    private lazy var pwTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.grayBackgroud
        textField.placeholder = " 현재 비밀번호를 입력해주세요"
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
        
        return textField
    }()
    
    private lazy var changePwTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.grayBackgroud
        textField.placeholder =  " 변경할 비밀번호를 입력해주세요"
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
        textField.placeholder = " 변경할 비밀번호를 입력해주세요"
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
    
    // 비밀번호 조건
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,16}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    // 비밀번호 변경 버튼
    private lazy var changePwButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("비밀번호 변경", for: .normal )
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.MainBackground
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(changePwButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "비밀번호 변경"
        self.view.backgroundColor = .white
        
        setupViews()
        updateChangePwButtonState()
    }
    
    // 오토레이아웃 설정
    private func setupViews() {
        self.view.addSubview(pwLabel)
        self.view.addSubview(pwTextField)
        self.view.addSubview(changePwLabel)
        self.view.addSubview(changePwTextField)
        self.view.addSubview(checkPwLabel)
        self.view.addSubview(checkpwTextField)
        self.view.addSubview(changePwButton)
        
        pwLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalToSuperview().offset(30)
        }
        
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(pwLabel.snp.bottom).offset(8)
            make.leading.equalTo(pwLabel)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        
        changePwLabel.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(20)
            make.leading.equalTo(pwLabel)
        }
        
        changePwTextField.snp.makeConstraints { make in
            make.top.equalTo(changePwLabel.snp.bottom).offset(8)
            make.leading.equalTo(changePwLabel)
            make.trailing.equalTo(pwTextField)
            make.height.equalTo(50)
        }
        
        checkPwLabel.snp.makeConstraints { make in
            make.top.equalTo(changePwTextField.snp.bottom).offset(20)
            make.leading.equalTo(pwLabel)
        }
        
        checkpwTextField.snp.makeConstraints { make in
            make.top.equalTo(checkPwLabel.snp.bottom).offset(8)
            make.leading.equalTo(checkPwLabel)
            make.trailing.equalTo(pwTextField)
            make.height.equalTo(50)
        }
        
        changePwButton.snp.makeConstraints { make in
            make.top.equalTo(checkpwTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
    }
    
    // 모든 필드가 채워져 있는지 확인하는 함수
    private func areFieldsFilled() -> Bool {
        return !(pwTextField.text?.isEmpty ?? true) &&
        !(changePwTextField.text?.isEmpty ?? true) &&
        !(checkpwTextField.text?.isEmpty ?? true)
    }
    
    // 비밀번호 버튼의 상태를 업데이트하는 함수
    private func updateChangePwButtonState() {
        if areFieldsFilled() {
            changePwButton.backgroundColor = UIColor.MainBackground
            changePwButton.isEnabled = true
        } else {
            changePwButton.backgroundColor = UIColor(hexCode: "C1C1C1")
            changePwButton.isEnabled = false
        }
    }
    
    // 텍스트 필드의 편집이 변경될 때마다 비밀번호 버튼 상태를 업데이트
    @objc func textFieldDidChangeSelection(_ textField: UITextField) {
        updateChangePwButtonState()
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
        changePwTextField.isSecureTextEntry.toggle()
        checkpwTextField.isSecureTextEntry.toggle()
    }
    
    // 텍스트 필드 파란 형태
    @objc func textFieldBlue(_ textField: UITextField) {
        textField.backgroundColor = UIColor(hexCode: "#F2F4FF")
        textField.layer.borderColor = UIColor.MainBackground.cgColor
        textField.layer.borderWidth = 1.0
        textField.textColor = UIColor.MainBackground
        
        if textField == pwTextField {
            addLeftPadding(to: textField, image: UIImage(named: "userOn")!, paddingWidth: 30, paddingHeight: 20)
        }
    }
    
    // 텍스트 필드 빨간 형태
    @objc func textFieldRed(_ textField: UITextField) {
        textField.backgroundColor = UIColor(hexCode: "#FFF6F6")
        textField.layer.borderColor = UIColor.MainBackground.cgColor
        textField.layer.borderWidth = 1.0
        textField.textColor = UIColor(hexCode: "#FF2121")
        
        if textField == pwTextField {
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
        if textField == pwTextField {
            addLeftPadding(to: textField, image: UIImage(named: "user")!, paddingWidth: 30, paddingHeight: 20)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateChangePwButtonState()
    }
    
    // 비밀번호 변경 버튼 눌렀을 때 동작 구현
    @objc private func changePwButtonTapped() {
        guard let currentPw = pwTextField.text,
              let newPw = changePwTextField.text,
              let confirmPw = checkpwTextField.text
        else {
            showAlert(message: "모든 필드를 채워주세요")
            return
        }

        // 입력 검증
        if !isValidPassword(newPw) {
            showAlert(message: "변경할 비밀번호는 8~16자의 영문 대/소문자, 숫자, 특수문자로 입력해주세요.")
            return
        }
        
        if newPw != confirmPw {
            showAlert(message: "변경할 비밀번호와 확인 비밀번호가 일치하지 않습니다.")
            return
        }

        Task {
            do {
                // 비밀번호 변경 요청
                let changePasswordRequest = ChangePw(userPw: currentPw, changePw: newPw, confirmChangePw: confirmPw)
                let changePasswordResponse = try await FetchAPI.shared.changePassword(data: changePasswordRequest)
                print("Password Change Success: \(ChangePwResponse)")

                showAlert(message: "비밀번호가 성공적으로 변경되었습니다.")
                
            } catch {
                showAlert(message: "비밀번호 변경에 실패하였습니다.")
                print("Failed to change password: \(error)")
            }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
