//
//  RegisterViewModel.swift
//  abcplay
//
//  Created by Luis Domingues on 08/10/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import Foundation
import Moya
class RegisterViewModel {
    let provider = MoyaProvider<MoyaConfig>()
    
    func createUser(user: String, password: String, email: String, completion: @escaping (Bool, Error?) -> Void) {
        self.provider.request(.register(email: email, password: password, name: user, type: "estudante")) { result in
            switch result {
            case let .success(response):
                do {
                    let token = try response.map(Token.self)
                    self.saveToken(token: token.token)
                    completion(true, nil)
                } catch {
                    completion(false, nil)
                }
            case let .failure(error):
                completion(false, error)
            }
        }
    }
    
    private func saveToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: "token")
    }

}
