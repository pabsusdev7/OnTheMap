//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 7/14/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    
    var objectId: String?
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Float
    var longitude: Float
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case objectId
        case uniqueKey
        case firstName
        case lastName
        case mapString
        case mediaURL
        case latitude
        case longitude
        case createdAt
        case updatedAt
    }
    
}
