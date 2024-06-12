//
//  LoginModel.swift
//  Todo_list
//
//  Created by 이예나 on 5/28/24.
// 아이디와 비밀번호 이용
//
// 유효성 검사
//
// 아이디 & 비밀번호 모두 존재 및 일치해야 함

//

import Foundation

// MARK: - LoginResponse
//struct LoginResponse: Codable {
//    let memberId: Int
//    let userId: String
//}

// MARK: - LoginData
struct SignIn: Codable{
    let userId: String
    let userPw: String
}

struct SignInResponse: Codable{
    let accessToken: String
}
