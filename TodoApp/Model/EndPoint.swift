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
    case getTodo
    case addTodo( item: TodoRequest)
    case updateTodo(todoId: Int, item: UpdateTodoRequest)
    case deleteTodo(todoId: Int)
    case addCategory(item: CategoryRequest)
    case getCategory
    case updateCategory(categoryId: Int, item: CategoryRequest)
    case deleteCategory(categoryId: Int)
    case signIn(item: SignIn)
    case signUp(item: Signup)
    
    var path: String {
      
        switch self{
            
        case .addTodo(_):
            return "/todo"
            
        case .getTodo:
            return "/todo/todos"
            
        case .updateTodo(let todoId, _), 
                .deleteTodo(let todoId):
            return "/todo/\(todoId)"
            
        case .getCategory:
            return "/category/categories"
            
        case .addCategory(_):
            return "/category"
            
        case .updateCategory(let categoryId, _),
                .deleteCategory(let categoryId):
            return "/category/\(categoryId)"
            
        case .signUp(_):
            return "/member/sign-up"
            
        case .signIn(_):
            return "/member/sign-in"
        }
    }
    
    var url: URL? {
        let baseURL = "http://na2ru2.me:5151"
        return URL(string: baseURL + path)
    }
    
    var method: String {
        switch self {
        case .addTodo, .addCategory, .signIn, .signUp :
            return "POST"
        case .getTodo, .getCategory :
            return "GET"
        case .updateTodo, .updateCategory :
            return "PUT"
        case .deleteTodo, .deleteCategory :
            return "DELETE"
        }
    }
    
    var body: Data? {
        switch self {
        case .addTodo( let item):
            return try? JSONEncoder().encode(item)
        case .updateTodo(_,let item):
            return try? JSONEncoder().encode(item)
        case .addCategory( let category):
            return try? JSONEncoder().encode(category)
        case .updateCategory(_, let category):
            return try? JSONEncoder().encode(category)
        case .signIn(let item):
            return try? JSONEncoder().encode(item)
        case .signUp(let item):
            return try? JSONEncoder().encode(item)
        default :
            return nil
        }
    }
}

