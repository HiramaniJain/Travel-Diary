//
//  Response.swift
//  TravelDiary
//
//  Created by Heeral on 6/1/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation

var restaurants = [Restaurant]()

struct Restaurant {
    let name: String?
    let address: String?
    let latitude: Double
    let longitude: Double
}

struct FourSquare: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let venues: [Venue]
}

// MARK: - Venue
struct Venue: Codable {
    let name: String
    let location: Loc
}

// MARK: - Loc
struct Loc: Codable {
    let address: String
    let lat: Double
    let lng: Double
}
