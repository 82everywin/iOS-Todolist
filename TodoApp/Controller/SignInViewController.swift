import UIKit
import SnapKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var pwLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var idTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.grayBackgroud
        //textField.placeholder =  " 아이디를 입력해주세요"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor.MainBackground
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.returnKeyType = .next
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        
        textField.attributedPlaceholder = NSAttributedString(string: " 아이디를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexCode: "D0D0D0")])

        
        textField.addTarget(self, action: #selector(textFieldBlue(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldBasic(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)
                

        addLeftPadding(to: textField, image: UIImage(named: "user")!, paddingWidth: 40, paddingHeight: 20)
        return textField
    }()
    
    lazy var pwTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.grayBackgroud
       // textField.placeholder =  " 비밀번호를 입력해주세요"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor.MainBackground
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.returnKeyType = .next
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        textField.delegate = self
        
        textField.attributedPlaceholder = NSAttributedString(string: " 비밀번호를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexCode: "D0D0D0")])

        
        textField.addTarget(self, action: #selector(textFieldBlue(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldBasic(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)
               
        addLeftPadding(to: textField, image: UIImage(named: "Lock")!, paddingWidth: 40, paddingHeight: 20)
        addRightPadding(to: textField, image: UIImage(named: "Eye-closed")!, paddingWidth: 30, paddingHeight: 20, selector: #selector(togglePasswordVisibility(_:)))

        return textField
    }()
    
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle( "로그인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.MainBackground
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "로그인"
        
        setUpviews()
        updateLoginButtonState()
    }

    func setUpviews() {
        self.view.addSubview(idLabel)
        self.view.addSubview(idTextField)
        self.view.addSubview(pwLabel)
        self.view.addSubview(pwTextField)
        self.view.addSubview(loginButton)
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalTo(view).offset(25)
        }
        
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(8)
            make.leading.equalTo(idLabel)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(50)
        }
        
        pwLabel.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(30)
            make.leading.equalTo(idLabel)
        }
        
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(pwLabel.snp.bottom).offset(8)
            make.leading.equalTo(pwLabel)
            make.trailing.equalTo(idTextField)
            make.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(100)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).offset(-25)
            make.height.equalTo(55)
        }
    }
    
    // 모든 필드가 채워져 있는지 확인하는 함수
    func areFieldsFilled() -> Bool {
        return !(idTextField.text?.isEmpty ?? true) && !(pwTextField.text?.isEmpty ?? true)
    }
    
    // 로그인 버튼의 상태를 업데이트하는 함수
    func updateLoginButtonState() {
        if areFieldsFilled() {
            loginButton.backgroundColor = UIColor.MainBackground
            loginButton.isEnabled = true
            
        } else {
            loginButton.backgroundColor = UIColor(hexCode: "#C1C1C1")
            loginButton.isEnabled = false
        }
    }
    
    // 텍스트 필드의 편집이 변경될 때마다 로그인 버튼 상태를 업데이트
    @objc func textFieldDidChangeSelection(_ textField: UITextField){
        updateLoginButtonState()
    }
    
    
    // 텍스트 필드의 내부 이미지 패딩
    func addLeftPadding(to textField: UITextField, image: UIImage, paddingWidth: CGFloat, paddingHeight: CGFloat) {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingWidth, height: paddingHeight))
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 5, y: 0, width: paddingWidth - 10, height: paddingHeight)
        leftPaddingView.addSubview(imageView)
        
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
    }
    
    // 텍스트 필드의 내부이미지 패딩
    func addRightPadding(to textField: UITextField, image: UIImage, paddingWidth: CGFloat, paddingHeight: CGFloat, selector: Selector) {
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingWidth, height: paddingHeight))
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: -5, y: 0, width: paddingWidth - 10, height: paddingHeight)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
        
        rightPaddingView.addSubview(imageView)
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
    }
    
    // 비밀번호 암호화 처리
    @objc func togglePasswordVisibility(_ sender: UITapGestureRecognizer) {
        pwTextField.isSecureTextEntry.toggle()
    }
    
    // 텍스트 필드 파란 형태
    @objc func textFieldBlue(_ textField: UITextField) {
        textField.backgroundColor = UIColor(hexCode: "#F2F4FF")
        textField.layer.borderColor = UIColor.MainBackground.cgColor
        textField.layer.borderWidth = 1.0
    }
    
    // 텍스트 필드 빨간 형태
    @objc func textFieldRed(_ textField: UITextField) {
        textField.backgroundColor = UIColor(hexCode: "#FFF6F6")
        textField.layer.borderColor = UIColor(hexCode: "#FF2121").cgColor
        textField.layer.borderWidth = 1.0
    }
    
    // 텍스트 필드 기본 형태
    @objc func textFieldBasic(_ textField: UITextField) {
        textField.backgroundColor = UIColor.grayBackgroud
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
    }
    
    // 로그인 버튼 눌렀을 때 동작 구현
    @objc private func loginButtonTapped() {
        guard let setUserId = idTextField.text,
                let setUserPw = pwTextField.text
        else { return }
        
        
        Task {
            do {
                let newLogin = SignIn(userId: setUserId, userPw: setUserPw)
                
                let SignInResponse = try await FetchAPI.shared.signIn(data: newLogin)
                print("Permit Login: \(SignInResponse)")
                
                TokenAPI.shared.setToken(SignInResponse.token)
                
                let todoVC = TodoViewController(accToken: SignInResponse.token)
                navigationController?.pushViewController(todoVC, animated: true)
                
            } catch {
                let alert = UIAlertController(title: "Error", message: "아이디 및 비밀번호를 다시 입력해주세요!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                print("Failed to SignIn: \(error)")
            }
        }
    }
}

