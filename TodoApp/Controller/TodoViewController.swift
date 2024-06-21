//
//  TodoViewController.swift
//  TodoApp
//
//  Created by 한현승 on 5/25/24.
//
import UIKit
import SnapKit
import FSCalendar

final class TodoViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    var accToken: String
    
    init(accToken: String){
        self.accToken = accToken
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var categories: [CategoryResponse] = []
    var todos: [TodoResponse] = []
    var allTodos: [TodoResponse] = []
    
    var currentMonth: Int = Calendar.current.component(.month, from: Date())
    var currentDay: Int = Calendar.current.component(.day, from: Date())
    var selectedDates: [Date] = []
    var eventDates: [Date] = []
    var filteredDate: Date?
    
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
        label.font = UIFont.boldSystemFont(ofSize: 24)
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
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
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
        button.setImage(UIImage(named: "addTodo"), for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let calendarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    private let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.scope = .month
        calendar.backgroundColor = .white
        calendar.layer.cornerRadius = 10
        calendar.layer.masksToBounds = true
        return calendar
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
        
        calendarView.isHidden = true
        calendar.delegate = self
        calendar.dataSource = self
        calendar.isHidden = true
        
        menuButton.addTarget(self, action: #selector(goToMypage), for: .touchUpInside)
        calendarButton.addTarget(self, action: #selector(viewCalendar), for: .touchUpInside)
        addCategoryBtn.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        addTodoButton.addTarget(self, action: #selector(addTodo), for: .touchUpInside)
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftHandleSwipeGesture(_:)))
        leftSwipeGestureRecognizer.direction = .left
        todoView.addGestureRecognizer(leftSwipeGestureRecognizer)
        
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightHandleSwipeGesture(_:)))
        rightSwipeGestureRecognizer.direction = .right
        todoView.addGestureRecognizer(rightSwipeGestureRecognizer)
        
        
        setUpViews()
        updateMonthLabel()
        updateDayLabel()
        getCategoryTodo()
        calendarStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCategoryTodo()
        filterTodos()
        todoView.reloadData()
        updateEmptyState()
    }
    
    
    func setUpViews() {
        
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
            make.top.equalTo(logoImage.snp.bottom).offset(50)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(28)
            
        }
        
        self.view.addSubview(calendarButton)
        calendarButton.snp.makeConstraints{ make in
            make.top.equalTo(logoImage.snp.bottom).offset(50)
            make.leading.equalTo(monthLabel.snp.trailing).offset(3)
            make.height.width.equalTo(30)
        }
 
        self.view.addSubview(categoryView)
        self.categoryView.snp.makeConstraints{ make in
            make.top.equalTo(logoImage.snp.bottom).offset(45)
            make.leading.equalTo(calendarButton.snp.trailing).offset(30)
            make.trailing.equalTo(view).offset(-50)
            make.height.equalTo(40)
        }
       
        self.view.addSubview(addCategoryBtn)
        self.addCategoryBtn.snp.makeConstraints{ make in
            make.top.equalTo(logoImage.snp.bottom).offset(50)
            make.leading.equalTo(categoryView.snp.trailing).offset(5)
            make.width.height.equalTo(30)
        }
        
        self.view.addSubview(totalTodoView)
        self.totalTodoView.snp.makeConstraints{ make in
            make.top.equalTo(monthLabel.snp.bottom).offset(17)
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
            make.trailing.equalTo(view).offset(-20)
            make.bottom.equalTo(totalTodoView.snp.bottom).offset(-10)
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
    
    func calendarStyle() {
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.headerHeight = 60
        calendar.weekdayHeight = 22
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleColor = UIColor.MainBackground
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18)
        
        calendar.appearance.weekdayTextColor = UIColor(hexCode: "8E8E8E")
        calendar.appearance.selectionColor = UIColor(hexCode: "EEF3FF")
        calendar.appearance.eventSelectionColor = UIColor.MainBackground
        calendar.appearance.titleWeekendColor = UIColor(hexCode: "232323")
        calendar.appearance.titleDefaultColor = UIColor(hexCode: "232323")
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 12)
        calendar.appearance.subtitleFont = UIFont.systemFont(ofSize: 10)
        
        calendar.appearance.titleTodayColor = UIColor.MainBackground
        calendar.appearance.todayColor = UIColor(hexCode: "EEF3FF")
        calendar.appearance.todaySelectionColor = .none
    }
    
    func getCategoryTodo() {
        Task {
            do {
                self.categories = try await TokenAPI.shared.getCategory()
                self.todos = try await TokenAPI.shared.getTodo()
                self.allTodos = todos
                filterTodos()
                self.categoryView.reloadData()
                self.todoView.reloadData()
                self.updateEventDates()
                updateEmptyState()
            }catch {
                print("Failed to Fetch API data: \(error)")
            }
        }
    }
    
    func updateEmptyState() {
        if todos.isEmpty {
              let emptyLabel = UILabel()
              emptyLabel.text = "Todo일정을 추가해보세요!"
              emptyLabel.textColor = .gray
              emptyLabel.textAlignment = .center
              emptyLabel.tag = 999 // 고유 태그
              emptyLabel.frame = todoView.bounds
              todoView.backgroundView = emptyLabel
          } else {
              todoView.backgroundView = nil
          }
    }
    
    func updateEventDates() {
        for todo in allTodos {
            if let date = DateFormatterManager.shared.date(from: todo.setDate, format: "YYYY-MM-dd"){
                eventDates.append(date)
            }
        }
        calendar.reloadData()
    }
    
    func filterTodos() {
        guard let filteredDate = filteredDate else {
            allTodos = todos
            return
        }
        print("allTodos :\(allTodos)")
        print("todos: \(todos)")
        let dateString = DateFormatterManager.shared.string(from: filteredDate, format: "yyyy-MM-dd")
        print(dateString)
        self.todos = self.allTodos.filter{ todo in
            todo.setDate == dateString
        }
        print("filtered Todos ===> \(todos)")
        todoView.reloadData()
        updateEmptyState()
    }
    
    
    @objc func viewCalendar() {
        calendar.isHidden = false
        calendarView.isHidden = false
            
        let dimmedBackground = UIView()
        dimmedBackground.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmedBackground.frame = self.view.frame
        dimmedBackground.tag = 99
        
        let calendarView = UIView()
        calendarView.backgroundColor = .white
        calendarView.layer.cornerRadius = 10
        calendarView.layer.masksToBounds = true
         
        self.view.addSubview(dimmedBackground)
        self.view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view).multipliedBy(0.9)
            make.height.equalTo(calendarView.snp.width).multipliedBy(1.2)
        }
     
        calendarView.addSubview(calendar)
        calendar.snp.makeConstraints{ make in
            make.edges.equalToSuperview().inset(20)
         
        }
         
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissCalendar))
        dimmedBackground.addGestureRecognizer(tapGesture)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        filteredDate = date
        let month = DateFormatterManager.shared.string(from: date, format: "M")
        let day = DateFormatterManager.shared.string(from: date, format: "d")
        monthLabel.text = "\(month)월"
        dayLabel.text = "\(day)일"
        filterTodos()
        updateEmptyState()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return self.eventDates.contains(date) ? 1 : 0
        
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.MainBackground
    }
    
    
    @objc func dismissCalendar() {
        selectedDates.removeAll()
        
        self.view.viewWithTag(99)?.removeFromSuperview()
        self.view.subviews.last?.removeFromSuperview()
        calendar.isHidden = true
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
    
    @objc func leftHandleSwipeGesture(_ gesture: UISwipeGestureRecognizer){
        let location = gesture.location(in: todoView)
        if let indexPath = todoView.indexPathForItem(at: location) {
            let cell = todoView.cellForItem(at: indexPath) as! TodoViewCell
            cell.deleteButton.isHidden = false
            UIView.animate(withDuration: 0.6) {
                cell.contentView.frame.origin.x = -60
            }
        }
    }
    
    @objc func rightHandleSwipeGesture(_ gesture: UISwipeGestureRecognizer){
        let location = gesture.location(in: todoView)
        if let indexPath = todoView.indexPathForItem(at: location) {
            print("Swiped item Num. \(indexPath)")
            let cell = todoView.cellForItem(at: indexPath) as! TodoViewCell
            if( cell.deleteButton.isHidden == false){
                UIView.animate(withDuration: 0.5) {
                    cell.contentView.frame.origin.x = 0
                }
                cell.deleteButton.isHidden = true
            }
        }
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        Task{
            do {
                let msg = try await TokenAPI.shared.deleteTodo(todoId: todos[index].todoId )
                print("Successed Delete Todo: \(msg)")
                DispatchQueue.main.async {
                    self.todos.remove(at: index)
                    self.todoView.reloadData()
                    self.updateEmptyState()
                }
            }
            catch{
                print("Failed Delete Todo")
            }
        }
        todoView.reloadData()
        updateEmptyState()
       }
    
    @objc func addTodo() {
        let TodoDetailVC = TodoDetailViewController()
        navigationController?.pushViewController(TodoDetailVC, animated: true)
    }
    
    @objc func addCategory(){
        let addCateVC = CategoryDetailViewController(accToken: self.accToken)
        navigationController?.pushViewController(addCateVC, animated: true)
    }
    
    @objc func goToMypage() {
        let myPageVC = MyPageViewController(accToken: self.accToken)
        navigationController?.pushViewController(myPageVC, animated: true)
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
            cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
            cell.deleteButton.tag = indexPath.item
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          if collectionView == categoryView {
              let category = categories[indexPath.item]
              let width = category.content.size(withAttributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]).width
              return CGSize(width: width + 10, height : 28 )
              
          } else {
              return CGSize(width: collectionView.frame.width , height: 50)
          }
      }
    
    
    // category
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    // todo
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryView && indexPath.item < categories.count {
            let selectedCategory = categories[indexPath.item]
            let categoryVC = CategoryDetailViewController(accToken: self.accToken)
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
}
