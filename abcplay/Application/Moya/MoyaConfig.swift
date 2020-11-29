//
//  MoyaConfig.swift
//  abcplay
//
//  Created by Luis Domingues on 08/10/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import Foundation
import Moya
enum MoyaConfig {
    case user
    case login(email: String, password: String)
    case register(email: String, password: String, name: String, type: String)
    case serie
    case getProfessores
    case resultado(title: String, acertos: Int, erros: Int)
    case delProfessor(id: String)
    case addProfessor(user: User, professor: Professor)
}

extension MoyaConfig: TargetType {
    var baseURL: URL {
        return URL(string: "https://abcplayback.azurewebsites.net")!
    }
    
    var path: String {
        switch self {
        case .login(_, _):
            return "/login"
        case .register(_, _, _, _):
            return "/cadastro"
        case .user:
            return "/user"
        case .serie:
            return "/serie"
        case .resultado(_, _, _):
            return "/desempenho"
        case .getProfessores:
            return "/professores"
        case .delProfessor(_):
            return "/delProf"
        case .addProfessor(_):
            return "/addProfessor"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register, .login, .resultado, .delProfessor, .addProfessor:
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .login(email, password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case let .register(email, password, name, _):
            return .requestParameters(parameters: ["email": email, "password": password, "name": name, "type": "estudante"], encoding: JSONEncoding.default)
        case let .resultado(title, acertos, erros):
            return .requestParameters(parameters: ["title": title, "acertos": acertos, "erros": erros], encoding: JSONEncoding.default)
        case let .delProfessor(id):
            return .requestParameters(parameters: ["_id": id], encoding: JSONEncoding.default)
        case let .addProfessor(user, professor):
            if let desempenho = user.desempenho {
                let json = convertDic(dic: desempenho)
                return .requestParameters(parameters: ["_id": professor.id, "username": professor.username, "email": professor.email, "estudante": user.username, "desempenho": json], encoding: JSONEncoding.default)
            } else {
                return .requestParameters(parameters: ["_id": professor.id, "username": professor.username, "email": professor.email, "estudante": user.username], encoding: JSONEncoding.default)
            }
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login(_, _), .register(_, _, _, _):
            return ["Content-type": "application/json"]
        default:
            return ["Content-type": "application/json",
                    "x-auth-token": UserDefaults.standard.string(forKey: "token")!
            ]
        }
    }
    private func convertDic(dic: [String:User.Desempenho]) -> String {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dic) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        return ""
    }
}
