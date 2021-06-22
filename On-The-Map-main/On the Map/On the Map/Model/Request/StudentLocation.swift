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
    
    init(firstName: String, lastName: String, mapString: String, uniqueKey: String, objectId: String, latitude: Double, longitude: Double, createdAt: String, updatedAt: String, mediaURL: String){
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.uniqueKey = uniqueKey
        self.objectId = objectId
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.mediaURL = mediaURL
    }
}

