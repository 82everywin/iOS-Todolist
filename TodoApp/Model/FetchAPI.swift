//
//  fetchAPI.swift
//  TodoApp
//
//  Created by 한현승 on 5/26/24.
//

import Foundation


class FetchAPI {
    
    static let shared = FetchAPI()
    
    private init() {}
   
    func fetchAPI<T: Decodable> (_ endpoint: EndPoint) async throws -> T {
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
    
    func addTodo(memberId: Int, todo: AddTodo) async throws -> AddTodo {
        try await fetchAPI(.addTodo(memberId: memberId, item: todo))
    }
    func getTodo(memberId: Int) async throws -> [Todo] {
        try await fetchAPI(.getTodo(memberId: memberId))
    }
    func updateTodo(todoId: Int, todo: Todo) async throws -> Todo {
        try await fetchAPI(.updateTodo(todoId: todoId, item: todo))
    }
    func deleteTodo(todoId: Int) async throws -> Todo{
        try await fetchAPI(.deleteTodo(todoId: todoId))
    }
    
    func addCategory(memberId: Int, category: AddCategory) async throws -> AddCategory {
        try await fetchAPI(.addCategory(memberId: memberId, item: category))
    }
    func getCategory(memberId: Int) async throws -> [Category] {
        try await fetchAPI(.getCategory(memberId: memberId))
    }
    func updateCategory(categoryId: Int, category: Category) async throws -> Category {
        try await fetchAPI(.updateCategory(categoryId: categoryId, item: category))
    }
    func deleteCategory(categoryId: Int) async throws -> [Category] {
        try await fetchAPI(.deleteCategory(categoryId: categoryId))
    }
    func signIn(data: SignIn) async throws -> LoginResponse {
        try await fetchAPI(.signIn(item: data))
    }
    func signUp(data: Signup) async throws -> SignupResponse {
        try await fetchAPI(.signUp(item: data))
    }
}
