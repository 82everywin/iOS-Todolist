//
//  AddCategoryViewController.swift
//  TodoApp
//
//  Created by 한현승 on 5/28/24.
//

import UIKit
import SnapKit

final class CategoryDetailViewController: UIViewController {
    
    var accToken: String
    
    init(accToken: String){
        self.accToken = accToken
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var categoryId: Int?
    private var previousSeletedButton: UIButton?
    var selectedCategory: CategoryResponse?
    
    private lazy var categoryNameView: UIView = {
            let view = UIView()
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.3
            view.layer.shadowRadius = 3
            view.layer.shadowOffset = CGSize(width: 2, height: 8)
            view.layer.masksToBounds = false
            return view
    }()
    
    private lazy var categoryContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lineColor.cgColor
        return view
    }()

   private lazy var selectedColorMini: UILabel = {
       let label = UILabel()
       label.backgroundColor = UIColor.white
       label.layer.cornerRadius = 13
       label.layer.masksToBounds = true //뷰의 하위 뷰가 부모 뷰의 경계를 넘어서 그려지는 것을 제어 (true => 잘림)
       return label
    }()
    
    private let categoryName: UITextField = {
        let field = UITextField()
        field.placeholder = "추가할 카테고리를 입력해주세요!"
        field.font = UIFont.systemFont(ofSize: 16)
        field.textColor = UIColor(hexCode: "232323")
        field.layer.borderColor = UIColor.clear.cgColor
        field.layer.masksToBounds = true
        
        field.attributedPlaceholder = NSAttributedString(string: "추가할 카테고리를 입력해주세요!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexCode: "D0D0D0")])
      
        return field
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Color"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor(hexCode: "232323")
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var colorSelectionView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lineColor.cgColor
        view.layer.shadowColor = UIColor.lineColor.cgColor
        view.layer.masksToBounds = true
        view.layer.shadowOffset = CGSize(width: 2, height: 5)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 3
        return view
    }()
    
    let colors: [String] = ["FFE560", "47D2CA", "F9B0CA", "B6B0F9"]
    private var selectedColor: String?
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.MainBackground
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(saveCategory), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(UIColor(hexCode: "A2A2A2"), for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hexCode: "A2A2A2").cgColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(deleteCategory), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "카테고리"
        
        setUpViews()
        setupColorButtons()
        didSelectCategory()
        
        NotificationCenter.default.addObserver(self, selector: #selector(categoryDeleted), name: NSNotification.Name( "CategoryDeleted"), object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setUpViews() {
      
        self.view.addSubview(categoryNameView)
        self.categoryNameView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(view).offset(14)
            make.trailing.equalTo(view).offset(-14)
            make.height.equalTo(53)
        }
        
        self.view.addSubview(categoryContentView)
        self.categoryContentView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(view).offset(14)
            make.trailing.equalTo(view).offset(-14)
            make.height.equalTo(53)
        }
        
        categoryContentView.addSubview(selectedColorMini)
        selectedColorMini.snp.makeConstraints{ make in
            make.centerY.equalTo(categoryNameView)
            make.leading.equalTo(categoryNameView.snp.leading).offset(6)
            make.width.height.equalTo(26)
        }

        categoryContentView.addSubview(categoryName)
        categoryName.snp.makeConstraints{ make in
            make.leading.equalTo(selectedColorMini.snp.trailing).offset(7)
            make.trailing.equalTo(categoryNameView.snp.trailing).offset(-2)
            make.centerY.equalTo(categoryNameView)
        }
        
        self.categoryName.becomeFirstResponder()
        self.categoryName.delegate = self
        
        self.view.addSubview(colorSelectionView)
        self.colorSelectionView.snp.makeConstraints{ make in
            make.top.equalTo(categoryNameView.snp.bottom).offset(50)
            make.leading.equalTo(view).offset(14)
            make.trailing.equalTo(view).offset(-14)
            make.height.equalTo(190)
        }
        
        colorSelectionView.addSubview(colorLabel)
        colorLabel.snp.makeConstraints{make in
            make.top.equalTo(colorSelectionView.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(addButton)
           addButton.snp.makeConstraints { make in
               make.height.equalTo(50)
           }

       view.addSubview(deleteButton)
       deleteButton.snp.makeConstraints { make in
           make.height.equalTo(50)
       }
    }
    
    private func setupColorButtons() {
        let buttonWidth = (view.frame.width - 100) / CGFloat(colors.count)
        for (index, colorHex) in colors.enumerated() {
            let button = UIButton()
            
            button.backgroundColor = UIColor(hexCode: colorHex)
            button.layer.cornerRadius = buttonWidth / 2
            button.tag = index
            button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
            
            colorSelectionView.addSubview(button)
            button.snp.makeConstraints { make in
                make.width.height.equalTo(buttonWidth)
                make.leading.equalToSuperview().offset(20 + CGFloat(index) * (buttonWidth + 10))
                make.centerY.equalToSuperview().offset(20)
            }
        }
    }
    
    private func didSelectCategory() {
           if let selected = selectedCategory {
               categoryId = selected.categoryId
               categoryName.text = selected.content
               selectedColor = selected.color
               for subview in colorSelectionView.subviews {
                   if let button = subview as? UIButton, button.backgroundColor == UIColor(hexCode: selected.color) {
                       button.setImage(UIImage(named: "Check_Big"), for: .normal)
                       selectedColorMini.backgroundColor = UIColor(hexCode: selected.color)
                   }
               }

           deleteButton.isHidden = false
                 addButton.setTitle("저장", for: .normal)
                 
                 deleteButton.snp.remakeConstraints { make in
                     make.top.equalTo(colorSelectionView.snp.bottom).offset(60)
                     make.leading.equalTo(view).offset(15)
                     make.width.equalTo(view.frame.width / 2 - 20)
                     make.height.equalTo(50)
                 }
                 
                 addButton.snp.remakeConstraints { make in
                     make.top.equalTo(colorSelectionView.snp.bottom).offset(60)
                     make.trailing.equalTo(view).offset(-15)
                     make.width.equalTo(view.frame.width / 2 - 20)
                     make.height.equalTo(50)
                 }
                 
             } else {
                 deleteButton.isHidden = true
                 addButton.setTitle("저장하기", for: .normal)
                 
                 addButton.snp.remakeConstraints { make in
                     make.top.equalTo(colorSelectionView.snp.bottom).offset(60)
                     make.leading.equalTo(view).offset(15)
                     make.trailing.equalTo(view).offset(-15)
                     make.height.equalTo(50)
                 }
             }
    }
    
    @objc func colorButtonTapped(_ sender: UIButton ) {
           for subview in colorSelectionView.subviews {
               if let button = subview as? UIButton {
                   button.setImage(nil, for: .normal)
               }
           }
           if let previousButton = previousSeletedButton {
               previousButton.setImage(nil, for: .normal)
           }
           sender.setImage(UIImage(named: "Check_Big"), for: .normal)
           selectedColor = colors[sender.tag]
           selectedColorMini.backgroundColor = UIColor(hexCode: selectedColor!)

           previousSeletedButton = sender
    }
    
    @objc func saveCategory() {
        guard let content = categoryName.text, !content.isEmpty,
              let color = selectedColor  else {
            let alert = UIAlertController(title: "Error", message: "양식을 채워주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return}
        
        Task {
            do {
                if selectedCategory != nil {
                    let newCategory = CategoryRequest(content: content, color: color)
                    let updatedCategory = try await TokenAPI.shared.updateCategory(categoryId: categoryId!, category: newCategory)
                    print("Category update :\(updatedCategory)")
                }
                else {
                    let newCategory = CategoryRequest(content: content, color: color)
                    let addedCategory = try await TokenAPI.shared.addCategory(category: newCategory)
                    print("Category added: \(addedCategory)")
                }
                
                navigationController?.popViewController(animated: true)
                
            }catch {
                let alert = UIAlertController(title: "Error", message: "Failed to add category", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                print("Failed to add category: \(error)")
            }
        }
    }
    
    @objc func deleteCategory() {
        guard let content = categoryName.text, !content.isEmpty  else { return}
        
        let modalVC = DeleteCategoryViewController(accToken: accToken, 
                                                   categoryId: categoryId!,
                                                   categoryName: categoryName.text!)
        modalVC.modalPresentationStyle = .overFullScreen
        self.present(modalVC, animated: false, completion: nil)
    }
    
    @objc func categoryDeleted() {
        _ = TodoViewController(accToken: accToken)
        self.navigationController?.popViewController(animated: true)
    }

}

extension CategoryDetailViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.tintColor = UIColor.clear
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        categoryName.tintColor = .gray
        return true
    }
}
