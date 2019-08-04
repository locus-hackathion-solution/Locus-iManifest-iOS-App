//
//  RoouteInputParameter.swift
//  Mapbox SDK Example
//
//  Created by Pankaj Kulkarni on 04/08/19.
//  Copyright © 2019 iManifest. All rights reserved.
//

import Foundation

// MARK: - RoouteInputParameter
struct RoouteInputParameter: Codable {
    let source: Destination
    let destination: Destination
    let time: String

    enum CodingKeys: String, CodingKey {
        case source = "source"
        case destination = "destination"
        case time = "time"
    }
}

// MARK: - Destination
struct Destination: Codable {
    let lat: String
    let lon: String

    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lon = "lon"
    }
}
