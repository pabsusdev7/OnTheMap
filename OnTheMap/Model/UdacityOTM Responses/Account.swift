//
//  Account.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 8/4/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import Foundation

struct Account: Codable {
    
    var registered: Bool
    var key: String
    
    enum CodingKeys: String, CodingKey {
        case registered
        case key
    }
    
}
