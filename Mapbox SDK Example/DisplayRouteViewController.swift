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
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var inputContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collapseButton: UIButton!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!



    lazy var route: Routes = {
        return Routes.loadJSONData()
    }()


    var layers: [MGLLineStyleLayer] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        createMapViewAndAddSourceDestinationAnnotation()
        inputContainerView.roundBottomCorners(withRadius: 10)
        inputContainerView.dropShadow()
    }

    private func createMapViewAndAddSourceDestinationAnnotation() {
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(mapView, belowSubview: inputContainerView)

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
    fileprivate func collapseInputContainerView() {
        inputContainerHeightConstraint.constant = 14

        UIView.animate(withDuration: 0.5) {
            self.expandButton.isHidden = false
            self.clearButton.isHidden = true
            self.routeButton.isHidden = true
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func collapseButtonPressed(_ sender: UIButton) {
        print("Collapse Button Pressed")
        collapseInputContainerView()
    }

    fileprivate func expandInputContainerView() {
        inputContainerHeightConstraint.constant = 200

        UIView.animate(withDuration: 0.5) {
            self.expandButton.isHidden = true
            self.clearButton.isHidden = false
            self.routeButton.isHidden = false
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func expandButtonPressed(_ sender: UIButton) {
        print("Expand Button Pressed")
        expandInputContainerView()
    }

    @IBAction func routeButtonPressed(_ sender: UIButton) {


        layers.forEach { (layer) in
            mapView.style?.removeLayer(layer)
        }
        layers.removeAll()

        mapView.setCenter(CLLocationCoordinate2D(latitude: 12.933663, longitude: 77.688818), zoomLevel: 12.5, animated: true)

        collapseInputContainerView()
        NetworkManager.getRoute(completion: handleGetRouteResponse(routes:error:))

    }

    func handleGetRouteResponse(routes: Routes?, error: Error?) {
        guard error == nil else {
            print("Error fetching route")
            expandInputContainerView()
            return
        }

        if let routes = routes {
            route = routes
            route.route.segments.forEach { (segment) in
                addPolyline(to: mapView.style!, color: segment.uiColor)
                addPolyline(withCoordinates: segment.coordinates)
            }
        }
    }

    private func addPolyline(to style: MGLStyle, color: UIColor) {
        // Add an empty MGLShapeSource, we’ll keep a reference to this and add points to this later.
        let source = MGLShapeSource(identifier: "polyline\(Date().timeIntervalSince1970)", shape: nil, options: nil)
        style.addSource(source)
        polylineSource = source

        // Add a layer to style our polyline.
        let layer = MGLLineStyleLayer(identifier: "polyline\((Date().timeIntervalSince1970))", source: source)
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        layer.lineColor = NSExpression(forConstantValue: color)

        // The line width should gradually increase based on the zoom level.
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                       [14: 3, 18: 20])
        style.addLayer(layer)
        layers.append(layer)
    }

    private func addPolyline(withCoordinates coordinates: [CLLocationCoordinate2D]) {
        var mutableCoordinates = coordinates

        let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))

        // Updating the MGLShapeSource’s shape will have the map redraw our polyline with the current coordinates.
        polylineSource?.shape = polyline
    }

}



extension DisplayRouteViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
