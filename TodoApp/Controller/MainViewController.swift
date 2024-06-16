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
    
    // todoList 로고 구현 - 배열과 랜덤한 인덱스 사용
    private let logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LongLogo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 하단에 로그인 버튼 구현
    private lazy var loginButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor(hexCode: "#FFFFFF"), for: .normal)
        button.backgroundColor = UIColor.MainBackground
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.isEnabled = true
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 하단에 회원가입 버튼 구현
    private lazy var signupButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor.MainBackground, for: .normal)
        button.backgroundColor = .clear // 버튼 배경색: 투명
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.layer.borderWidth = 1   // 버튼의 테두리 두께
        button.layer.borderColor = UIColor.MainBackground.cgColor
        // 버튼의 테두리 색 설정
        button.isEnabled = true // 버튼의 동작 설정 (처음에 동작 on)
        button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)

        return button
    }()
    
    // 사진&로그인버튼 & 회원가입 버튼을 스택뷰로 묶기
    lazy var stackView: UIStackView = {
        let spacerView = UIView() //특정 내부간격 설정
        spacerView.snp.makeConstraints { make in
                   make.height.equalTo(40)
        }
        let stView = UIStackView(arrangedSubviews: [mainImage, logoImage, spacerView, loginButton, signupButton])
        
        stView.spacing = 20    // 객체의 내부 간격 설정
        stView.axis = .vertical  // 세로 묶음으로 정렬 (가로 묶음은 horizontal)
        stView.distribution = .fillProportionally  // 각 객체의 크기(간격) 분배 설정 (fillEqually: 여기서는 동일하게 분배)
        stView.alignment = .fill  // 정렬 설정 (fill: 전부 채우는 설정)
        return stView
    }()
    
    // + 각 텍스트필드 및 로그인 버튼의 높이 설정
    private let textViewHeight: CGFloat = 27
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setUpviews()
    }
       
   func setUpviews() {
       view.addSubview(stackView)
       // 스택 뷰의 위치 및 크기 설정
       stackView.snp.makeConstraints { make in
           make.centerX.equalTo(view)
           make.centerY.equalTo(view)
           make.leading.equalTo(view).offset(30)
           make.trailing.equalTo(view).offset(-30)
       }
       
       // mainImage의 높이와 너비 제약 조건 설정 (스택 뷰 내부에서 관리됨)
       mainImage.snp.makeConstraints { make in
           make.height.equalTo(230)
           make.width.equalTo(230)
       }
       
       // logoImage의 높이와 너비 제약 조건 설정 (스택 뷰 내부에서 관리됨)
       logoImage.snp.makeConstraints { make in
           make.height.equalTo(64)
           make.width.equalTo(261)
       }
       
       // 로그인 버튼과 회원가입 버튼의 높이 및 너비 설정
       loginButton.snp.makeConstraints { make in
           make.height.equalTo(55)
           make.width.equalTo(326)
       }
       
       signupButton.snp.makeConstraints { make in
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

