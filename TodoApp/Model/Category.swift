//
//  Cetegory.swift
//  TodoApp
//
//  Created by 한현승 on 5/26/24.
//

import Foundation


struct Category : Codable{
    var categoryId: Int
    var content: String
    var color: String
}

struct AddCategory: Codable{
    var content: String
    var color: String
}
