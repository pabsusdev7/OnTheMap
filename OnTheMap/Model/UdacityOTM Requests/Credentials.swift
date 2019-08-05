//
//  Credentials.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 8/4/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import Foundation

struct Credentials: Codable{
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}
