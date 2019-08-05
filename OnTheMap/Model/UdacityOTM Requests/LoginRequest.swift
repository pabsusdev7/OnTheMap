//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 8/4/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    
    let udacity: Credentials
    
    enum CodingKeys: String, CodingKey {
        case udacity
    }
    
}
