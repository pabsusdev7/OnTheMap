//
//  StudentLocationResponse.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 7/31/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import Foundation

struct StudentLocationResponse: Codable {
    
    let createdAt: String
    let objectId: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectId
    }
    
}
