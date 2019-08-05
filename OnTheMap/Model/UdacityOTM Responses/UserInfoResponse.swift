//
//  User.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 8/5/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import Foundation

struct UserInfoResponse: Codable {
    
    var firstName: String
    var lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
}
