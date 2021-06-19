//
//  PostSession.swift
//  On the Map
//
//  Created by YoYo on 2021-06-11.
//

import Foundation
struct PostSession: Codable {
    let account: SessionForAccount
    let session: SessionForSession
}

struct SessionForAccount: Codable {
    let registered: Bool
    let key: String
}

struct SessionForSession: Codable {
    let id: String
    let expiration: String
}
