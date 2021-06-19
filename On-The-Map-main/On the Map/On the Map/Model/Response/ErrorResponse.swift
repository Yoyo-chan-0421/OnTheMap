//
//  ErrorResponse.swift
//  On the Map
//
//  Created by YoYo on 2021-06-11.
//

import Foundation
struct ErrorResponse: Codable, Error {
    let status: Int
    let error: String
}

extension ErrorResponse: LocalizedError{
    var errorDescription: String?{
        return error
    }
}
