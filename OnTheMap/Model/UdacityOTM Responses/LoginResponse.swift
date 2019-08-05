//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 8/4/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    
    let account: Account
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case account
        case session
    }
    
}
