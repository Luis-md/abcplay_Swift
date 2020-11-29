//
//  AddProfessorViewModel.swift
//  abcplay
//
//  Created by Luis Domingues on 28/11/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import Foundation
import Moya
class AddProfessorViewModel {
    let provider = MoyaProvider<MoyaConfig>()
    
    func getProfessores(completion: @escaping ([Professor]?, Bool, Error?) -> Void) {
        self.provider.request(.getProfessores) { result in
            switch result {
            case let .success(response):
                do {
                    let professores = try response.map([Professor].self)
                    completion(professores, true, nil)
                } catch {
                    completion(nil, false, nil)
                }
            case let .failure(error):
                completion(nil, false, error)
            }
        }
    }
    
    func delProfessor(id: String, completion: @escaping (Bool, Error?) -> Void) {
        self.provider.request(.delProfessor(id: id)) { result in
            switch result {
            case .success(_):
                completion(true, nil)
            case let .failure(error):
                completion(false, error)
            }
        }
    }
    
    func addProfessor(professor: Professor, completion: @escaping (Bool, Error?) -> Void) {
        self.getUser { (user, success, error) in
            if let err = error {
                completion(false, err)
            } else {
                if let user = user {
                    self.provider.request(.addProfessor(user: user, professor: professor)) { result in
                        switch result {
                        case .success(_):
                            completion(true, nil)
                        case let .failure(error):
                            completion(false, error)
                        }
                    }
                }
            }
        }
    }

    private func getUser(completion: @escaping (User?, Bool, Error?) -> Void) {
        self.provider.request(.user) { result in
            switch result {
            case let .success(response):
                do {
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
