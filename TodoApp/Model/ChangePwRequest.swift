//
//  ChangePw.swift
//  TodoApp
//
//  Created by 이예나 on 6/21/24.
//

import Foundation

// MARK: - ChangePwResponse
struct ChangePwResponse: Codable {
    let memberId: Int
    let userId: String
}

// MARK: - ChangePwRequest
struct ChangePwRequest: Codable {
    let userPw: String
    let changePw: String
    let confirmChangePw: String
}
