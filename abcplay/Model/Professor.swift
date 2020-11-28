//
//  Professor.swift
//  abcplay
//
//  Created by Luis Domingues on 28/11/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import Foundation

struct Professor: Codable {
    var alunos: [String:Alunos]?
    var email: String
    var id: String
    var type: String
    var username: String
}

extension Professor {
    struct Alunos: Codable {
        var estudante: String
    }
}

