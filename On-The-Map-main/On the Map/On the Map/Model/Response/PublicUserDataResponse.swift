//
//  PublicUserDataResponse.swift
//  On the Map
//
//  Created by YoYo on 2021-06-15.
//

import Foundation


struct PublicUserDataResponse: Codable {
    let lastName: String
    let firstName: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        case key
    }
}


