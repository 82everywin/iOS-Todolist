//
//  SignUp.swift
//  TodoApp
//
//  Created by 한현승 on 6/5/24.
//

import Foundation


// MARK: - SignupResponse
struct SignupResponse: Codable {
    let memberId: Int
    let userId: String
}

// MARK: - SingupData
struct Signup: Codable{
    let userId: String
    let userPw: String
    let confirmUserPw: String
}
