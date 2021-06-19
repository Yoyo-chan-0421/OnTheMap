//
//  StudentLocation.swift
//  On the Map
//
//  Created by YoYo on 2021-06-10.
//

import Foundation
struct StudentLocation: Codable {
    var firstName: String
    var lastName: String
    var mapString: String
    var uniqueKey: String
    var objectId: String
    var latitude: Double
    var longitude: Double
    var createdAt: String
    var updatedAt: String
    var mediaURL: String
}

