//
//  Model.swift
//  Mapbox SDK Example
//
//  Created by Pankaj Kulkarni on 04/08/19.
//  Copyright © 2019 iManifest. All rights reserved.
//

import Foundation
import Mapbox

// MARK: - Routes
struct Routes: Codable {
    let source: NamedWaypoint
    let destination: NamedWaypoint
    let startDate: String
    let startTime: String
    let distance: Double
    let duration: Double
    let route: Route

    enum CodingKeys: String, CodingKey {
        case source = "source"
        case destination = "destination"
        case startDate = "startDate"
        case startTime = "startTime"
        case distance = "distance"
        case duration = "duration"
        case route = "route"
    }

    static public func loadJSONData() -> Routes {
        let pathURL = Bundle.main.url(forResource: "Routes", withExtension: "json")!
        do {
            let data = try Data(contentsOf: pathURL)
            let route = try JSONDecoder().decode(Routes.self, from: data)

            return route
        } catch {
            print("Error decoding JSON data.")
            fatalError()
        }
    }

}

// MARK: - Destination
struct NamedWaypoint: Codable {
    let name: String
    let lat: Double
    let long: Double

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case lat = "lat"
        case long = "long"
    }
}

// MARK: - Route
struct Route: Codable {
    let segments: [Segment]

    enum CodingKeys: String, CodingKey {
        case segments = "segments"
    }
}

// MARK: - Segment
struct Segment: Codable {
    let waypoints: [Waypoint]
    let color: String

    enum CodingKeys: String, CodingKey {
        case waypoints = "waypoints"
        case color = "color"
    }

    var uiColor: UIColor {
        switch color {
        case "red":
            return .red
        case "green":
            return .green
        case "blue":
            return .blue
        default:
            return .gray
        }
    }

    var coordinates: [CLLocationCoordinate2D] {
        return waypoints.map { $0.coordinate }
    }
}

// MARK: - Waypoint
struct Waypoint: Codable {
    let lat: Double
    let lon: Double

    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lon = "lon"
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
