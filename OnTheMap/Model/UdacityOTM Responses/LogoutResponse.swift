//
//  LogoutResponse.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 8/5/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import Foundation
struct LogoutResponse: Codable {
    
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case session
    }
    
}
