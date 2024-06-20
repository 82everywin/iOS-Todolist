//
//  TokenAPI.swift
//  TodoApp
//
//  Created by 한현승 on 6/16/24.
//

import Foundation

class TokenAPI {
    static let shared = TokenAPI()
    
    private var token: String
    
    private init(token: String = "") {
        self.token = token
    }
    
    func setToken(_ token: String) {
        self.token = token
    }
    

    func tokenAPI<T: Decodable> (_ endpoint: EndPoint) async throws -> T {
        guard let url = endpoint.url else {
            throw FetchError.invalidURL
        }
        print(url)
        var request  = URLRequest(url : url)
        request.httpMethod = endpoint.method
        if let body = endpoint.body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
    
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //상태 가져오기
        guard let httpResponse = response as? HTTPURLResponse else {
            throw FetchError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...300 :
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        case 400...499 :
            throw FetchError.statuscodeError(httpResponse.statusCode)
        case 500...600 :
            throw FetchError.statuscodeError(httpResponse.statusCode)
        default :
            throw FetchError.statuscodeError(httpResponse.statusCode)
        }

    }
    
    
    func addTodo( todo: TodoRequest) async throws -> TodoResponse {
        try await tokenAPI(.addTodo(item: todo))
    }
    func getTodo() async throws -> [TodoResponse] {
        try await tokenAPI(.getTodo)
    }
    func updateTodo(todoId: Int, todo: UpdateTodoRequest) async throws -> TodoResponse{
        try await tokenAPI(.updateTodo(todoId: todoId, item: todo))
    }
    func deleteTodo(todoId: Int) async throws -> Msg{
        try await tokenAPI(.deleteTodo(todoId: todoId))
    }
    func addCategory(category: CategoryRequest) async throws -> CategoryResponse{
        try await tokenAPI(.addCategory(item: category))
    }
    func getCategory() async throws -> [CategoryResponse] {
        try await tokenAPI(.getCategory)
    }
    func updateCategory(categoryId: Int, category: CategoryRequest) async throws -> CategoryResponse {
        try await tokenAPI(.updateCategory(categoryId: categoryId, item: category))
    }
    func deleteCategory(categoryId: Int) async throws -> Msg {
        try await tokenAPI(.deleteCategory(categoryId: categoryId))
    }
    
    func getMember() async throws -> getMemberResponse {
        try await tokenAPI(.getMember)
    }
    func deleteMember() async throws -> Msg {
        try await tokenAPI(.deleteMember)
    }
}
