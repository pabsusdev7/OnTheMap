//
//  StudentLocationResults.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 7/14/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import Foundation

struct StudentLocationResults: Codable {
    
    let results: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
}
