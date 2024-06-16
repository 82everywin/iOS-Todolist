//
//  Cetegory.swift
//  TodoApp
//
//  Created by 한현승 on 5/26/24.
//

import Foundation

struct CategoryResponse: Codable{
    var categoryId: Int
    var content: String
    var color: String
}

struct CategoryRequest: Codable{
    var content: String
    var color: String
}

struct CategoryTodoRequest: Codable{
    var categoryId: Int
    var content: String
    var color: String
}


//"category": {
//    "categoryId": 1,
//    "content": "약속",
//    "color": "FFFFFF"
//  }
