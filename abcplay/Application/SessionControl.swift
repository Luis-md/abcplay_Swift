//
//  SessionControl.swift
//  abcplay
//
//  Created by Luis Domingues on 18/10/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import Foundation
class SessionControl {
    
    static var headers: [String : String] = [:]

    static var token: Token?
    
    static var isSessionActive: Bool {
        if let _ = self.token {
            return true
        }
        return false
    }
    
    static func setHeaders() {
        if let token = self.token {
            self.headers["x-auth-token"] = token.token
            print(self.headers["token"] ?? "-")
        }
    }
}
