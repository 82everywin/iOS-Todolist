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
    
    func signIn(data: SignIn) async throws -> SignInResponse {
        try await fetchAPI(.signIn(item: data))
    }
    func signUp(data: Signup) async throws -> SignupResponse {
        try await fetchAPI(.signUp(item: data))
    }
}
