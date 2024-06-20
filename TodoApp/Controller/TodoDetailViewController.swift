//
//  TodoDetailViewController.swift
//  TodoApp
//
//  Created by 한현승 on 5/29/24.
//
import UIKit
import SnapKit

class TodoDetailViewController: UIViewController {
    
    var categories: [CategoryResponse] = []
    var selectedCategoryIndex: Int?
    var selectedTodo : TodoResponse?
    var selectedCategory: CategoryResponse?

    var choiceCategory: CategoryTodoRequest = CategoryTodoRequest(categoryId: 0)
    var categoryRequest: CategoryRequest = CategoryRequest(content: "", color: "")
    
    var currentMonth = Calendar.current.component(.month, from: Date())
    var currentDay = Calendar.current.component(.day, from: Date())
    
    var selectDate: String?
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = UIColor.labelFontColor
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = UIColor.labelFontColor
        return label
    }()
    
    private let calendarButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setImage(UIImage(named: "Calendar_Days"), for: .normal)
        button.tintColor = UIColor.MainBackground
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lineColor.cgColor
        button.layer.shadowColor = UIColor(hexCode: "000000").cgColor
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.masksToBounds = false
        return button
    }()
    
    private let todoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lineColor.cgColor
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 2, height: 4 )
        view.layer.shadowRadius = 5
        view.layer.masksToBounds = false
        return view
    }()
    
    private let todoName: UITextField = {
        let field = UITextField()
        field.placeholder = "To do를 입력해주세요!"
        field.font = UIFont.systemFont(ofSize: 16)
        field.textColor = UIColor(hexCode: "232323")
        field.backgroundColor = UIColor.white
        field.clipsToBounds = true
        
        field.attributedPlaceholder = NSAttributedString(string: "To do를 입력해주세요!", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexCode: "D0D0D0")])
        return field
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor(hexCode: "232323")
        return label
    }()
    
    private let categoryPreviwLabel: UILabel = {
        let label = UILabel()
        label.text = "To do의 카테고리를 선택해주세요!"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(hexCode: "8C8C8C")
        return label
    }()
    
    private let categoryCollectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lineColor.cgColor
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 2, height: 4 )
        view.layer.shadowRadius = 5
        view.layer.masksToBounds = false
        return view
    }()
    
    private let categoryView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let categorys = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categorys.backgroundColor = UIColor.white
        categorys.showsHorizontalScrollIndicator = false
        return categorys
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle( "확인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.MainBackground
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Todo"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        selectDate = dateFormatter.string(from: currentDate)
        
        self.categoryView.register(CategoryViewCell.self, forCellWithReuseIdentifier: CategoryViewCell.identifier)
        self.categoryView.delegate = self
        self.categoryView.dataSource = self
        
        calendarButton.addTarget(self, action: #selector(viewCalendar), for: .touchUpInside)
        todoName.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)
        saveButton.addTarget(self, action: #selector(saveTodo), for: .touchUpInside)
               
        setUpViews()
        updateMonthLabel()
        updateDayLabel()
        getCategory()
     //   getTodo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setUpViews() {
        
        self.view.addSubview(monthLabel)
        monthLabel.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(view).offset(20)
         //   make.width.equalTo(55)
        }
        
        self.view.addSubview(dayLabel)
        dayLabel.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(monthLabel.snp.trailing).offset(2)
         //   make.width.equalTo(60)
        }
        
        self.view.addSubview(calendarButton)
        calendarButton.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(dayLabel.snp.trailing).offset(6)
            make.width.height.equalTo(30)
        }
        
        self.view.addSubview(todoView)
        todoView.snp.makeConstraints{ make in
            make.top.equalTo(monthLabel.snp.bottom).offset(13)
            make.leading.equalTo(view).offset(10)
            make.trailing.equalTo(view).offset(-10)
            make.height.equalTo(55)
        }
        
        todoView.addSubview(todoName)
        todoName.snp.makeConstraints{ make in
            make.leading.equalTo(todoView.snp.leading).offset(15)
            make.trailing.equalTo(todoView.snp.trailing).offset(-3)
            make.height.equalTo(55)
        }
        
        self.view.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints{ make in
            make.top.equalTo(todoName.snp.bottom).offset(40)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(100)
        }
        
        self.view.addSubview(categoryPreviwLabel)
        categoryPreviwLabel.snp.makeConstraints{ make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(5)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(300)
            make.height.equalTo(25)
        }
        
        self.view.addSubview(categoryCollectionView)
        categoryCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(categoryPreviwLabel.snp.bottom).offset(15)
            make.leading.equalTo(view).offset(10)
            make.trailing.equalTo(view).offset(-10)
            make.height.equalTo(100)
        }
        
        categoryCollectionView.addSubview(categoryView)
        categoryView.snp.makeConstraints{ make in
            make.leading.equalTo(categoryCollectionView.snp.leading).offset(5)
            make.trailing.equalTo(categoryCollectionView.snp.trailing).offset(-5)
            make.centerY.equalTo(categoryCollectionView.snp.centerY)
            make.height.equalTo(60)
        }
        
        self.view.addSubview(saveButton)
        saveButton.snp.makeConstraints{ make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(40)
            make.leading.equalTo(view).offset(10)
            make.trailing.equalTo(view).offset(-10)
            make.height.equalTo(55)
        }
    }
    
    func updateMonthLabel(){
        monthLabel.text = "\(currentMonth)월"
    }
    
    func updateDayLabel() {
        dayLabel.text = "\(currentDay)일"
    }
    
    func areFieldsFilled() -> Bool {
        return !(todoName.text?.isEmpty ?? true)
    }
    
    func updateButtonState() {
        if areFieldsFilled() {
            saveButton.backgroundColor = UIColor.MainBackground
            saveButton.isEnabled = true
        } else {
            saveButton.backgroundColor = UIColor(hexCode: "#C1C1C1")
            saveButton.isEnabled = false
        }
    }
    
    func getTodo() {
        if let todo = selectedTodo {
            todoName.text = todo.content
            if let date = DateFormatterManager.shared.date(from: todo.setDate, format: "yyyy-MM-dd"){
                currentMonth = Calendar.current.component(.month, from: date)
                currentDay = Calendar.current.component(.day, from: date)
                updateMonthLabel()
                updateDayLabel()
                selectDate = todo.setDate
            }
            selectedCategory = todo.category
            
            if let index = categories.firstIndex(where: { $0.categoryId == todo.category.categoryId }) {
                selectedCategoryIndex = index
                choiceCategory = CategoryTodoRequest(categoryId: categories[index].categoryId)
            }
            categoryView.reloadData()
        }
    }
    
    func getCategory() {
        Task {
            do {
                self.categories = try await TokenAPI.shared.getCategory()
                self.categoryView.reloadData()
                getTodo()
            }catch {
                print("Failed to Fetch API data: \(error)")
            }
        }
    }
    
    @objc func textFieldDidChangeSelection(_ textField: UITextField){
        updateButtonState()
    }
    
    @objc func viewCalendar() {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .inline
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ko-KR")
        picker.backgroundColor = .white
        picker.tintColor = UIColor.MainBackground
        if #available(iOS 14.0, *) {
               picker.overrideUserInterfaceStyle = .light  
            // 이 설정은 모든 텍스트와 배경을 라이트 모드로 강제합니다.
        }
        picker.layer.cornerRadius = 10
        picker.layer.masksToBounds = true
        picker.addTarget(self, action: #selector(changeDate(sender:)), for: UIControl.Event.valueChanged)
        
        let pickerWrapper = UIView()
        pickerWrapper.backgroundColor = .white
        pickerWrapper.layer.cornerRadius = 10
        pickerWrapper.layer.masksToBounds = true
        pickerWrapper.addSubview(picker)
        
        let dimmedBackground = UIView()
        dimmedBackground.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmedBackground.frame = self.view.frame
        dimmedBackground.tag = 99
        
        self.view.addSubview(dimmedBackground)
        self.view.addSubview(pickerWrapper)
        
        pickerWrapper.snp.makeConstraints{ make in
            make.center.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.9)
            make.height.equalTo(pickerWrapper.snp.width).multipliedBy(1.2)
        }
        
        picker.snp.makeConstraints{ make in
            make.edges.equalTo(pickerWrapper).inset(10)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker))
        dimmedBackground.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissDatePicker(){
        self.view.viewWithTag(99)?.removeFromSuperview()
        self.view.subviews.last?.removeFromSuperview()
    }
    
    @objc func changeDate(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        selectDate = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "M"
        monthLabel.text = "\(dateFormatter.string(from: sender.date))월"
        dateFormatter.dateFormat = "d"
        dayLabel.text = "\(dateFormatter.string(from: sender.date))일"
    }
    
    
    @objc func saveTodo() {
        guard let todo = todoName.text, !todo.isEmpty else { return }
        
        Task{
            do {
                if selectedTodo != nil {
                    let newTodo = UpdateTodoRequest(content: todo, checked: selectedTodo!.checked, setDate: selectDate!, categoryId: choiceCategory.categoryId)
                    let updateTodo = try await TokenAPI.shared.updateTodo(todoId: selectedTodo!.todoId, todo: newTodo)
                } else {
                    let newTodo = TodoRequest(content: todo, setDate: selectDate!, categoryId: choiceCategory.categoryId)
                    let addTodo = try await TokenAPI.shared.addTodo(todo: newTodo)
                }
                navigationController?.popViewController(animated: true)
                
            } catch {
                let alert = UIAlertController(title: "Error", message: "할 일 생성에 실패하였습니다. 잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                print("Failed to add Todo: \(error)")
            }
        }
    }
}


extension TodoDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.identifier, for: indexPath) as? CategoryViewCell else { return UICollectionViewCell() }
        let category = categories[indexPath.item]
        let isSelected = indexPath.item == selectedCategoryIndex
        if selectedCategoryIndex != nil { // 선택 후
            if isSelected {
                cell.configure(with: categories[selectedCategoryIndex!])
                choiceCategory = CategoryTodoRequest(categoryId: categories[selectedCategoryIndex!].categoryId)
            } else{
                cell.choice(with: category)
            }
        }
        else{ // 선택 전
            cell.configure(with: category)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let category = categories[indexPath.item]
        let width = category.content.size(withAttributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]).width
        return CGSize(width: width + 10, height : 30 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.item
        choiceCategory = CategoryTodoRequest( categoryId: categories[selectedCategoryIndex!].categoryId)
        collectionView.reloadData()
        updateButtonState()
    }
}
