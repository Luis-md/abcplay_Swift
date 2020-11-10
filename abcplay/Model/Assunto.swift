//
//  Assunto.swift
//  abcplay
//
//  Created by Luis Domingues on 25/10/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import Foundation

struct Assunto: Codable {
    let assuntos: [Questoes]
    let serie: String
}

extension Assunto {
    struct Questoes: Codable {
        let questoes: [Quiz]
        let title: String
    }
}

extension Assunto {
    struct Quiz: Codable {
        let alt: [String]
        let pergunta: String
        let resp: Int
    }
}


