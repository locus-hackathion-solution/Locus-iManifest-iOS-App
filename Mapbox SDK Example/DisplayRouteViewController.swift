//
//  DIsplayRouteViewController.swift
//  Mapbox SDK Example
//
//  Created by Pankaj Kulkarni on 04/08/19.
//  Copyright © 2019 iManifest. All rights reserved.
//

import UIKit
import Mapbox

class DisplayRouteViewController: UIViewController {

    var mapView: MGLMapView!
    var polylineSource: MGLShapeSource?

    lazy var route: Routes = {
        return Routes.loadJSONData()
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        createMapViewAndAddSourceDestinationAnnotation()
    }

    private func createMapViewAndAddSourceDestinationAnnotation() {
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)

        mapView.delegate = self


        let sourceLocation = CLLocationCoordinate2D(latitude: route.source.lat, longitude: route.source.long)
        let destinationLocation = CLLocationCoordinate2D(latitude: route.destination.lat, longitude: route.destination.long)
        let sourceAnnotation = MGLPointAnnotation()
        sourceAnnotation.coordinate = sourceLocation
        sourceAnnotation.title = route.source.name
        mapView.addAnnotation(sourceAnnotation)

        let destinationAnnotation = MGLPointAnnotation()
        destinationAnnotation.coordinate = destinationLocation
        destinationAnnotation.title = route.destination.name

        mapView.addAnnotation(destinationAnnotation)
    }

}



extension DisplayRouteViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
