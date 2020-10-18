//
//  ViewModel.swift
//  abcplay
//
//  Created by Luis Domingues on 18/10/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import Foundation
import Moya
class ViewModel {
    let provider = MoyaProvider<MoyaConfig>()
        
    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        self.provider.request(.login(email: email, password: password)) { result in
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
