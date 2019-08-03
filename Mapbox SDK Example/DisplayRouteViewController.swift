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
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!



    lazy var route: Routes = {
        return Routes.loadJSONData()
    }()


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
    @IBAction func collapseButtonPressed(_ sender: UIButton) {
        print("Collapse Button Pressed")
        inputContainerHeightConstraint.constant = 14

        UIView.animate(withDuration: 0.5) {
//            self.collapseButton.isHidden = true
            self.expandButton.isHidden = false
            self.clearButton.isHidden = true
            self.okButton.isHidden = true
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func expandButtonPressed(_ sender: UIButton) {
        print("Expand Button Pressed")
        inputContainerHeightConstraint.constant = 200

        UIView.animate(withDuration: 0.5) {
            self.expandButton.isHidden = true
//            self.collapseButton.isHidden = false
            self.clearButton.isHidden = false
            self.okButton.isHidden = false
            self.view.layoutIfNeeded()
        }
    }


}



extension DisplayRouteViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
