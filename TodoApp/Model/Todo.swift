//
//  Todo.swift
//  TodoApp
//
//  Created by 한현승 on 5/26/24.
//

import Foundation

//JSON - Response
//{
//  "todoId": 1,
//  "content": "친구랑 치킨집",
//  "checked": false,
//  "setDate": "2024-06-16",
//  "category": {
//    "categoryId": 1,
//    "content": "약속",
//    "color": "FFFFFF"
//  }
//}

struct TodoResponse: Codable{
    var todoId: Int
    var content: String
    var checked: Bool
    var setDate: String
    var category: CategoryResponse
}

struct TodoRequest: Codable{
    var content: String
    var setDate: String
    var categoryId: Int
}

struct UpdateTodoRequest: Codable{
    var content: String
    var checked: Bool
    var setDate: String
    var categoryId: Int
}
