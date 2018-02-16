//
//  UserManager.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 13/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import Foundation

class UserInfoManager {
    let accessToken: String
    var user: SPTUser!
    
    init(accessToken: String, user: SPTUser?, completion: ((SPTUser?)->())? = nil) {
        self.accessToken = accessToken
        
        if let user = user {
            self.user = user
            completion?(user)
        } else {
            requestUser(completion: completion)
        }
        
    }
    
    private func requestUser(completion: ((SPTUser?)->())? = nil) {
        SPTUser.requestCurrentUser(withAccessToken: accessToken) {(error, data) in
            guard let user = data as? SPTUser else {
                completion?(nil)
                return
            }
            completion?(user)
        }
    }
}
