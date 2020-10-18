//
//  HomeViewModel.swift
//  abcplay
//
//  Created by Luis Domingues on 18/10/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import Foundation
import Moya
class HomeViewModel {
    let provider = MoyaProvider<MoyaConfig>()
    
    func getUser(completion: @escaping (User?, Bool, Error?) -> Void) {
        self.provider.request(.user) { result in
            switch result {
            case let .success(response):
                do {
                  // 4
                    let user = try response.map(User.self)
                    completion(user, true, nil)
                } catch {
                    completion(nil, false, nil)
                }
            case let .failure(error):
                completion(nil, false, error)
            }
        }
    }

}
