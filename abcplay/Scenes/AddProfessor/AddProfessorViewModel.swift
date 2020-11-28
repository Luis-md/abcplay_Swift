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
}
