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
    case register(email: String, password: String, name: String, type: String)
}

extension MoyaConfig: TargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:3333")!
    }
    
    var path: String {
        switch self {
        case .register(_, _, _, _):
            return "/cadastro"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register:
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
        case let .register(email, password, name, _):
            return .requestParameters(parameters: ["email": email, "password": password, "name": name, "type": "estudante"], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
