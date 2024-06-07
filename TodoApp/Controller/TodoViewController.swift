//
//  TodoViewController.swift
//  TodoApp
//
//  Created by 한현승 on 5/25/24.
//
import UIKit
import SnapKit

final class TodoViewController: UIViewController {
    
    var memberId: Int
    
    init(memberId: Int){
        self.memberId = memberId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var categories: [CategoryResponse] = []
    var todos: [Todo] = []
    var currentMonth: Int = Calendar.current.component(.month, from: Date())
    var currentDay: Int = Calendar.current.component(.day, from: Date())
    
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "TodoLogo")
        return image
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "profile-circle"), for: .normal)
        return button
    }()
    
    private let monthContainer = UIView()
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = UIColor.labelFontColor
        return label
    }()
    
    private let calendarButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setImage(UIImage(named: "Calendar_Days"), for: .normal)
        button.tintColor = UIColor(hexCode: "4260FF")
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lineColor.cgColor
        button.layer.shadowColor = UIColor(hexCode: "000000").cgColor
        button.layer.shadowOffset = CGSize(width: 3, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.masksToBounds = false
        return button
    }()
    
    
    private let categoryView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let categorys = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categorys.backgroundColor = UIColor.white
        categorys.showsHorizontalScrollIndicator = false
        return categorys
    }()
    
    
    private let addCategoryBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.backgroundColor = UIColor.grayBackgroud
        button.setTitleColor( UIColor(hexCode:"A2A2A2"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let totalTodoView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
        view.layer.cornerRadius = 10
//        view.layer.shadowColor = UIColor(hexCode: "000000").cgColor
//        view.layer.masksToBounds = false
//        view.layer.shadowOffset = CGSize(width: 2, height: 4)
//        view.layer.shadowOpacity = 0.3
//        view.layer.shadowRadius = 5
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.labelFontColor
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let todoView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let todos = UICollectionView(frame: .zero, collectionViewLayout: layout)
        todos.backgroundColor = .clear
        todos.showsHorizontalScrollIndicator = false
        return todos
    }()
    
    private let addTodoButton: UIButton = {
       let button = UIButton()
        button.setTitle("TodoList 추가", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.backgroundColor = UIColor.grayBackgroud
        button.setTitleColor(UIColor(hexCode: "A2A2A2"), for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
 
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.categoryView.register(CategoryViewCell.self, forCellWithReuseIdentifier: CategoryViewCell.identifier)
        self.categoryView.delegate = self
        self.categoryView.dataSource = self
        
        self.todoView.register(TodoViewCell.self, forCellWithReuseIdentifier: TodoViewCell.identifier)
        self.todoView.delegate = self
        self.todoView.dataSource = self
        
        menuButton.addTarget(self, action: #selector(goToMypage), for: .touchUpInside)
        calendarButton.addTarget(self, action: #selector(viewCalendar), for: .touchUpInside)
        addCategoryBtn.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        
        addTodoButton.addTarget(self, action: #selector(addTodo), for: .touchUpInside)
        
        setUpViews()
        updateMonthLabel()
        updateDayLabel()
        getCategoryTodo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCategoryTodo()
    }
    
    
    func setUpViews() {
        
//        [].forEach {
//            self.view.addSubview($0)
//        }
        
        self.view.addSubview(logoImage)
        logoImage.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(80)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        self.view.addSubview(menuButton)
        menuButton.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(80)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(13)
        }
        
        self.view.addSubview(monthLabel)
        monthLabel.snp.makeConstraints{ make in
            make.top.equalTo(logoImage.snp.bottom).offset(33)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(25)
            
        }
        
        self.view.addSubview(calendarButton)
        calendarButton.snp.makeConstraints{ make in
            make.top.equalTo(logoImage.snp.bottom).offset(33)
            make.leading.equalTo(monthLabel.snp.trailing).offset(3)
            make.height.width.equalTo(30)
        }
 
   
        self.view.addSubview(categoryView)
        self.categoryView.snp.makeConstraints{ make in
            make.top.equalTo(logoImage.snp.bottom).offset(30)
            make.leading.equalTo(calendarButton.snp.trailing).offset(10)
            make.trailing.equalTo(view).offset(-50)
            make.height.equalTo(40)
        }
       
        self.view.addSubview(addCategoryBtn)
        self.addCategoryBtn.snp.makeConstraints{ make in
            make.top.equalTo(logoImage.snp.bottom).offset(33)
            make.leading.equalTo(categoryView.snp.trailing).offset(5)
            make.width.height.equalTo(30)
        }
        
        self.view.addSubview(totalTodoView)
        self.totalTodoView.snp.makeConstraints{ make in
            make.top.equalTo(monthLabel.snp.bottom).offset(30)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(360)
        }
        
        totalTodoView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints{ make in
            make.top.equalTo(totalTodoView.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        totalTodoView.addSubview(todoView)
        self.todoView.register(TodoViewCell.self, forCellWithReuseIdentifier: TodoViewCell.identifier)
        self.todoView.snp.makeConstraints{ make in
            make.top.equalTo(dayLabel.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(30)
            make.trailing.equalTo(view).offset(-30)
            make.height.equalTo(230)
        }
    
        
        self.view.addSubview(addTodoButton)
        self.addTodoButton.snp.makeConstraints{ make in
            make.top.equalTo(totalTodoView.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(15)
            make.trailing.equalTo(view).offset(-15)
            make.height.equalTo(60)
        }
    }
    
    func updateMonthLabel(){
        monthLabel.text = "\(currentMonth)월"
    }
    
    func updateDayLabel() {
        dayLabel.text = "\(currentDay)일"
    }
    
    
    @objc func viewCalendar() {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .inline
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ko-KR")
        picker.backgroundColor = UIColor.white
        picker.tintColor = UIColor(hexCode: "4260FF")
        picker.addTarget(self, action: #selector(changeDate(sender:)), for: UIControl.Event.valueChanged)
        
        let pickerWrapper = UIView()
        pickerWrapper.backgroundColor = .clear
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
        dateFormatter.dateFormat = "M"
        monthLabel.text = "\(dateFormatter.string(from: sender.date))월"
        dateFormatter.dateFormat = "d"
        dayLabel.text = "\(dateFormatter.string(from: sender.date))일"
       // print("날짜 선택 \(monthLabel.text) ")
    }
    
    func getCategoryTodo() {
        Task {
            do {
                self.categories = try await FetchAPI.shared.getCategory(memberId: self.memberId)
                self.todos = try await FetchAPI.shared.getTodo(memberId: memberId)
                self.categoryView.reloadData()
                self.todoView.reloadData()

            }catch {
                print("Failed to Fetch API data: \(error)")
            }
        }
    }
    
}

extension TodoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return 31 }
  
}

extension TodoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryView {
            return categories.count
        }else {
            return todos.count
        }
    }
        
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryView {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.identifier, for: indexPath) as? CategoryViewCell else {
                    return UICollectionViewCell()
                }
                let category = categories[indexPath.item]
                cell.configure(with: category)
                return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoViewCell.identifier, for: indexPath) as? TodoViewCell else {
                return UICollectionViewCell()
            }
            cell.layer.cornerRadius = 10
            let todo = todos[indexPath.item]
            cell.configure(with: todo)
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          if collectionView == categoryView {
              let category = categories[indexPath.item]
              let width = category.content.size(withAttributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]).width
              return CGSize(width: width + 15, height : 30 )
              
          } else {
              return CGSize(width: collectionView.frame.width, height: 40) 
          }
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryView && indexPath.item < categories.count {
            let selectedCategory = categories[indexPath.item]
            let categoryVC = CategoryDetailViewController(memberId: self.memberId)
            categoryVC.selectedCategory = selectedCategory
            navigationController?.pushViewController(categoryVC, animated: true)
        }
        else {
            let selectedTodo = todos[indexPath.item]
            let todoDetailVC = TodoDetailViewController()
            todoDetailVC.selectedTodo = selectedTodo
            navigationController?.pushViewController(todoDetailVC, animated: true)
        }
    }
    
    
    @objc func addTodo() {
        let TodoDetailVC = TodoDetailViewController()
        navigationController?.pushViewController(TodoDetailVC, animated: true)
    }
    
    @objc func addCategory(){
        let addCateVC = CategoryDetailViewController(memberId: self.memberId)
        navigationController?.pushViewController(addCateVC, animated: true)
    }
    
    @objc func goToMypage() {
        let myPageVC = MyPageViewController()
        navigationController?.pushViewController(myPageVC, animated: true)
    }
    
  
}
