//
//  AnimateRouteViewController.swift
//  Mapbox SDK Example
//
//  Created by Pankaj Kulkarni on 03/08/19.
//  Copyright © 2019 iManifest. All rights reserved.
//

import Mapbox

class AnimateRouteViewController: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var timer: Timer?
    var polylineSource: MGLShapeSource?
    var currentIndex = 1
    var allCoordinates: [CLLocationCoordinate2D]!

    var timerTruncated: Timer?
    var polylineSourceTruncated: MGLShapeSource?
    var currentIndexTruncated = 1
    var allTruncatedCoordinates: [CLLocationCoordinate2D]!

    lazy var route: Routes? = {
        return Routes.loadJSONData()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let route = route {
            print("Numebr of coloured segments is \(route.route.segments.count)")
        }

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        mapView.setCenter(
            CLLocationCoordinate2D(latitude: 12.929651085287329, longitude: 77.68430573811855),
            zoomLevel: 12,
            animated: false)
        view.addSubview(mapView)
        let sourceLocation = CLLocationCoordinate2D(latitude: 12.935030, longitude: 77.703813)
        let destinationLocation = CLLocationCoordinate2D(latitude: 12.917433, longitude: 77.672480)
        let sourceAnnotation = MGLPointAnnotation()
        sourceAnnotation.coordinate = sourceLocation
        sourceAnnotation.title = "Source"
        mapView.addAnnotation(sourceAnnotation)

        let destinationAnnotation = MGLPointAnnotation()
        destinationAnnotation.coordinate = destinationLocation
        destinationAnnotation.title = "Destination"

        mapView.addAnnotation(destinationAnnotation)

        mapView.delegate = self

        allCoordinates = getCoordinates()
        allTruncatedCoordinates = getCoordinates(truncated: true)
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }

    // Wait until the map is loaded before adding to the map.
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        addPolyline(to: mapView.style!)
        animatePolyline()
    }

    func addPolyline(to style: MGLStyle) {
        // Add an empty MGLShapeSource, we’ll keep a reference to this and add points to this later.
        let source = MGLShapeSource(identifier: "polyline", shape: nil, options: nil)
        style.addSource(source)
        polylineSource = source

        // Add a layer to style our polyline.
        let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        layer.lineColor = NSExpression(forConstantValue: UIColor.red)

        // The line width should gradually increase based on the zoom level.
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                       [14: 3, 18: 20])
        style.addLayer(layer)
    }

    func addTruncatedPolyline(to style: MGLStyle) {
        // Add an empty MGLShapeSource, we’ll keep a reference to this and add points to this later.
        let source = MGLShapeSource(identifier: "polylineTruncated", shape: nil, options: nil)
        style.addSource(source)
        polylineSourceTruncated = source

        // Add a layer to style our polyline.
        let layer = MGLLineStyleLayer(identifier: "polylineTruncated", source: source)
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        layer.lineColor = NSExpression(forConstantValue: UIColor.green)

        // The line width should gradually increase based on the zoom level.
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                       [14: 3, 18: 20])
        style.addLayer(layer)
    }

    func animatePolyline() {
        currentIndex = 1

        // Start a timer that will simulate adding points to our polyline. This could also represent coordinates being added to our polyline from another source, such as a CLLocationManagerDelegate.
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }

    func animateTruncatedPolyline() {
        currentIndexTruncated = 1

        // Start a timer that will simulate adding points to our polyline. This could also represent coordinates being added to our polyline from another source, such as a CLLocationManagerDelegate.
        timerTruncated = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(tickTruncated), userInfo: nil, repeats: true)
    }

    @objc func tick() {
        if currentIndex > allCoordinates.count {
            timer?.invalidate()
            timer = nil
            print("Draw truncated route")
            // Draw truncated route
            addTruncatedPolyline(to: mapView.style!)
            animateTruncatedPolyline()
            return
        }

        // Create a subarray of locations up to the current index.
        let coordinates = Array(allCoordinates[0..<currentIndex])

        // Update our MGLShapeSource with the current locations.
        updatePolylineWithCoordinates(coordinates: coordinates)

        currentIndex += 1
    }

    @objc func tickTruncated() {
        if currentIndexTruncated > allTruncatedCoordinates.count {
            timerTruncated?.invalidate()
            timerTruncated = nil
            return
        }

        // Create a subarray of locations up to the current index.
        let coordinates = Array(allTruncatedCoordinates[0..<currentIndexTruncated])

        // Update our MGLShapeSource with the current locations.
        updatePolylineWithCoordinatesTruncated(coordinates: coordinates)

        currentIndexTruncated += 1
    }

    func updatePolylineWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
        var mutableCoordinates = coordinates

        let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))

        // Updating the MGLShapeSource’s shape will have the map redraw our polyline with the current coordinates.
        polylineSource?.shape = polyline
    }

    func updatePolylineWithCoordinatesTruncated(coordinates: [CLLocationCoordinate2D]) {
        var mutableCoordinates = coordinates

        let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))

        // Updating the MGLShapeSource’s shape will have the map redraw our polyline with the current coordinates.
        polylineSourceTruncated?.shape = polyline
    }

    private func getCoordinates(truncated: Bool = false) -> [CLLocationCoordinate2D] {
        let coordinates = [
            (12.935030171647654, 77.70381478539292),
            (12.93512715026737, 77.70380673876588),
            (12.935264026746147, 77.70379567465369),
            (12.935772221535451, 77.70380472710912),
            (12.93598428368569, 77.70379567465369),
            (12.936226101592169, 77.70378494581763),
            (12.936468254774809, 77.70376834964935),
            (12.936519132927057, 77.70376482924996),
            (12.936631282791497, 77.70345369300418),
            (12.936767153441917, 77.70320491811799),
            (12.936989022418864, 77.70272480270421),
            (12.937169149518015, 77.70233185908347),
            (12.937257997691624, 77.70209783634687),
            (12.937619090080252, 77.70107088557006),
            (12.937770970165722, 77.70063670298566),
            (12.937798127532016, 77.7004918636988),
            (12.937929136678575, 77.6998337166616),
            (12.938012201339008, 77.69936164787487),
            (12.93804321438074, 77.69920675030426),
            (12.938089314848181, 77.6990257011957),
            (12.93813206255435, 77.69883593490783),
            (12.938186042010775, 77.69855866155086),
            (12.938245134428145, 77.69827367684297),
            (12.93822912499308, 77.6982096391028),
            (12.938265083357688, 77.69803462496446),
            (12.938305232673883, 77.69784385284828),
            (12.938322247937318, 77.69779188504862),
            (12.938463063910588, 77.69743179848825),
            (12.938513103872534, 77.69738586565882),
            (12.938597090542322, 77.6972108515206),
            (12.938687279820439, 77.69702577909851),
            (12.93872223235665, 77.69695470055962),
            (12.938835304230444, 77.69672369530815),
            (12.939009144902226, 77.69630493542559),
            (12.939250292256459, 77.69567595741154),
            (12.939347019419065, 77.69536985030754),
            (12.93938549235463, 77.6952566107957),
            (12.939401250332587, 77.69520992359503),
            (12.93905910104512, 77.69497992417195),
            (12.938665067777032, 77.69462889006701),
            (12.938309172168363, 77.69426779767832),
            (12.937493277713639, 77.69339272698699),
            (12.93735698796808, 77.69333874753056),
            (12.936668163165434, 77.6925387786917),
            (12.935132011771191, 77.69085267504931),
            (12.934740241616955, 77.69044095596541),
            (12.932213013991712, 77.68769973835157),
            (12.93147322721779, 77.68688267043024),
            (12.931038290262208, 77.68643876483816),
            (12.930299090221506, 77.68558079322929),
            (12.929849149659281, 77.68492465784897),
            (12.929614540189501, 77.68449181636902),
            (12.929121097549782, 77.68342966159884),
            (12.92843520641327, 77.68188370337754),
            (12.92786104604601, 77.68065089305878),
            (12.927788123488423, 77.68049364855528),
            (12.927584275603293, 77.68007790615786),
            (12.92566406540573, 77.67618065645831),
            (12.924738954752675, 77.67422867884727),
            (12.924626218155028, 77.6739158662208),
            (12.924561174586414, 77.673749904538),
            (12.923730192705992, 77.67181267907654),
            (12.923148153349759, 77.67055069973469),
            (12.921948870643986, 77.66803084818366),
            (12.921926993876678, 77.6679848315353),
            (12.921813251450649, 77.66802875270787),
            (12.921728929504738, 77.66786983182374),
            (12.921357108280057, 77.66715066453145),
            (12.920681275427352, 77.66564091613179),
            (12.920592091977593, 77.66555575599557),
            (12.920536939054717, 77.66554309932178),
            (12.920494023710493, 77.66554066856986),
            (12.92014927603304, 77.66636175980483),
            (12.91993101127446, 77.66684187521861),
            (12.919813999906161, 77.66705376973079),
            (12.919561034068465, 77.66755668392113),
            (12.919173119589693, 77.66829395612433),
            (12.9190722014755, 77.66849176903918),
            (12.918853266164659, 77.66905369182791),
            (12.918689148500562, 77.6696018682955),
            (12.918452275916932, 77.67030293067694),
            (12.918365942314267, 77.6705376239658),
            (12.918181959539652, 77.67097482403528),
            (12.917890185490242, 77.67155887504845),
            (12.917783986777062, 77.67176574041878),
            (12.91768005117773, 77.67195181866919),
            (12.917556166648868, 77.67219690551804),
            (12.917420882731667, 77.67247367596076),
            ]
        print("Count: \(coordinates.count)")
        if truncated {
            let stringCoordinate = coordinates[...41].map {(String(format: "%.5f", $0.0), String(format: "%.5f", $0.1))}

            return stringCoordinate.map {CLLocationCoordinate2D(latitude: Double($0.0)!, longitude: Double($0.1)!)}
        } else {
            return coordinates[41...].map {CLLocationCoordinate2D(latitude: $0.0, longitude: $0.1)}
        }
    }


}


protocol Animations {
    func wiggle()
}

extension Animations where Self: UIView {
    func wiggle() {
        let position = "position"
        let wiggleAnimation = CABasicAnimation(keyPath: position)
        wiggleAnimation.duration = 0.05
        wiggleAnimation.repeatCount = 5
        wiggleAnimation.autoreverses = true
        wiggleAnimation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        wiggleAnimation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(wiggleAnimation, forKey: position)
    }
}

