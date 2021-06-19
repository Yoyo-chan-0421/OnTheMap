//
//  PostStudentLocation.swift
//  On the Map
//
//  Created by YoYo on 2021-06-11.
//

import Foundation
struct PostStudentLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
