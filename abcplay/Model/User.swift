//
//  User.swift
//  abcplay
//
//  Created by Luis Domingues on 17/10/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import Foundation

struct User: Codable {
    var desempenho: [String:Desempenho]?
    var email: String
    var id: String
    var type: String
    var username: String
}

extension User {
    struct Desempenho: Codable {
        var acertos: Int
        var erros: Int
        var title: String
        var today: String
    }
}

