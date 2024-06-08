//
//  Todo.swift
//  TodoApp
//
//  Created by 한현승 on 5/26/24.
//

import Foundation

//JSON - Request
//"content": "친구랑 홍대",
//"checked": true,
//"writeDate": "2024-06-07",
//"setDate": "2024-06-07",
//"category": {
//  "content": "약속",
//  "color": "FFFFFF"
//}

struct Todo: Codable{
    var todoId: Int
    var content: String
    var checked: Bool
    var category: CategoryResponse
}


struct AddTodo: Codable {
    var content: String
    var category: Category
}

struct TodoUpdateRequest: Codable{
    var todoId: Int
    var content: String
    var checked: Bool
    var writeDate: Date
    var setDate: Date
    var category: CategoryRequest
}
