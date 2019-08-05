//
//  Session.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 8/4/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import Foundation

struct Session: Codable {
    
    var id: String
    var expiration: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case expiration
    }
    
}
