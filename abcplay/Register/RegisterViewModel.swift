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
    
    func createUser(user: String, password: String, email: String, completion: @escaping (Bool) -> Void) {
        self.provider.request(.register(email: email, password: password, name: user, type: "estudante")) { result in
            print("user created")
            completion(true)
        }
    }
}
