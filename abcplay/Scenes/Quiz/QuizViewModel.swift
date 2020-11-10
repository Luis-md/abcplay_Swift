//
//  QuizViewModel.swift
//  abcplay
//
//  Created by Luis Domingues on 08/11/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import Foundation
import Moya
class QuizViewModel {
    let provider = MoyaProvider<MoyaConfig>()
    
    func sendResult(title: String, acertos: Int, erros: Int, completion: @escaping (Bool, Error?) -> Void) {
        self.provider.request(.resultado(title: title, acertos: acertos, erros: erros)) { result in
            switch result {
            case .success:
                completion(true, nil)
            case let .failure(error):
                completion(false, error)
            }
        }
    }

    
}
