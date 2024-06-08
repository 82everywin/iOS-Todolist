//
//  EndPoint.swift
//  TodoApp
//
//  Created by 한현승 on 5/30/24.
//

import Foundation


enum FetchError: Error {
    case invalidURL
    case invalidResponse
    case statuscodeError(Int)
    case serverError
    case NetworkError
}

enum EndPoint {
    case getTodo(memberId: Int)
    case addTodo(memberId: Int, item: AddTodo)
    case updateTodo(todoId: Int, item: TodoRequest)
    case deleteTodo(todoId: Int)
    case addCategory(memberId: Int, item: CategoryRequest)
    case getCategory(memberId: Int)
    case updateCategory(categoryId: Int, item: CategoryRequest)
    case deleteCategory(categoryId: Int)
    case member(Id: Int)
    case signIn (item: SignIn)
    case signup
    
    var url: URL? {
        let baseURL = "http://na2ru2.me:5151"
        switch self{
        case .getTodo(let memberId), .addTodo(let memberId, _):
            return URL(string: "\(baseURL)/todo/\(memberId)")
            
        case .updateTodo(let todoId, _), .deleteTodo(let todoId):
            return URL(string: "\(baseURL)/todo/\(todoId)")
            
        case .getCategory(let memberId):
            return URL(string: "\(baseURL)/category/categories/\(memberId)")
            
        case .addCategory(let memberId, _):
            return URL(string: "\(baseURL)/category/\(memberId)")
            
        case .updateCategory(let categoryId, _), .deleteCategory(let categoryId):
            return URL(string: "\(baseURL)/category/\(categoryId)")
            
        case .member(let memberId):
            return URL(string: "\(baseURL)/member/\(memberId)")
            
        case .signup:
            return URL(string: "\(baseURL)/member/sign-up")
        case .signIn:
            return URL(string: "\(baseURL)/member/sign-in")
        }
    }
    
    var method: String {
        switch self {
        case .addTodo, .addCategory, .signIn, .signup :
            return "POST"
        case .getTodo, .getCategory , .member:
            return "GET"
        case .updateTodo, .updateCategory :
            return "PUT"
        case .deleteTodo, .deleteCategory :
            return "DELETE"
        }
    }
    
    var body: Data? {
        switch self {
        case .addTodo(_, let item):
            return try? JSONEncoder().encode(item)
        case .updateTodo(_,let item):
            return try? JSONEncoder().encode(item)
        case .addCategory(_, let category):
            return try? JSONEncoder().encode(category)
        case .updateCategory(_, let category):
            return try? JSONEncoder().encode(category)
        case .signIn(let item)  :
            return try? JSONEncoder().encode(item)
        default :
            return nil
        }
    }
}
