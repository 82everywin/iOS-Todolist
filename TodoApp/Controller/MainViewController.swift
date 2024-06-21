import UIKit
import SnapKit

class MainViewController: UIViewController {
    // main화면 중앙 사진 랜덤 구현 - 배열과 랜덤한 인덱스 사용
    private var mainImage: UIImageView = {
        let image = UIImageView()
        let imageNames = ["Main1", "Main2", "Main3"]
        let randomIndex = Int.random(in: 0..<imageNames.count)
        let selectedImageName = imageNames[randomIndex] //select image
        image.image = UIImage(named: selectedImageName)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "longLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var loginButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor(hexCode: "#FFFFFF"), for: .normal)
        button.backgroundColor = UIColor.MainBackground
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isEnabled = true
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
 
    private lazy var signupButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.MainBackground, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.MainBackground.cgColor
        // 버튼의 테두리 색 설정
        button.isEnabled = true
        button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)

        return button
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setUpviews()
    }
       
   func setUpviews() {
   
       view.addSubview(mainImage)
       mainImage.snp.makeConstraints { make in
           make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
           make.centerX.equalToSuperview()
           make.height.equalTo(230)
           make.width.equalTo(230)
       }
       
       view.addSubview(logoImage)
       logoImage.snp.makeConstraints { make in
           make.top.equalTo(mainImage.snp.bottom).offset(40)
           make.leading.equalTo(view.safeAreaLayoutGuide).offset(25)
           make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-25)
           make.height.equalTo(60)
       }
       
       view.addSubview(loginButton)
       loginButton.snp.makeConstraints { make in
           make.top.equalTo(logoImage.snp.bottom).offset(120)
           make.centerX.equalToSuperview()
           make.height.equalTo(55)
           make.width.equalTo(326)
       }
       
       view.addSubview(signupButton)
       signupButton.snp.makeConstraints { make in
           make.top.equalTo(loginButton.snp.bottom).offset(15)
           make.centerX.equalToSuperview()
           make.height.equalTo(55)
           make.width.equalTo(326)
       }
   }

    @objc private func loginButtonTapped() {
        let loginVC = SignInViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc private func signupButtonTapped() {
        let SignupVC = SignupViewController()
        navigationController?.pushViewController(SignupVC, animated: true)
    }
}

