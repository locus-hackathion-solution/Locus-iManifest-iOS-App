//
//  ViewController.swift
//  Mapbox SDK Example
//
//  Created by Pankaj Kulkarni on 03/08/19.
//  Copyright © 2019 iManifest. All rights reserved.
//

import UIKit
import Mapbox



class ViewController: UIViewController {

    @IBOutlet weak var mapView: MGLMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserLocation()
    }

    func setupUserLocation() {
//        mapView.setCenter(CLLocationCoordinate2D(latitude: 12.923708, longitude: 77.671661), zoomLevel: 14, animated: false)
        view.addSubview(mapView)
        mapView.zoomLevel = 9
        mapView.showsUserLocation = true
        mapView.styleURL = MGLStyle.streetsStyleURL
        mapView.userTrackingMode = .follow
    }

//    private func calculateRoute(from originCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D, completion: @escaping (Route? Error?)->Void) {
//
////        let originWaypoint = Waypoint(
//
//    }


}

