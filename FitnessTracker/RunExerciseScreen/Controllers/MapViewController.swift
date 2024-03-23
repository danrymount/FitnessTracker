

import Foundation
import MapKit
import UIKit

protocol MapViewControllerProtocol {
    func clearRoute()
    func appendNewRoutePoint(location: CLLocationCoordinate2D)
    func setStartPoint(location: CLLocationCoordinate2D)
}

class MapCustomAnnotation: NSObject, MKAnnotation {
    enum EType {
        case startPoint
        case currentPoint
        
        func toImage() -> UIImage? {
            var imageView: UIImage?
            var imgName = "mappin.and.ellipse"
            switch self {
                case .startPoint:
                    imageView = UIImage(systemName: "mappin.and.ellipse")
                case .currentPoint:
                    imageView = UIImage(systemName: "target")?.withTintColor(.systemBlue)
            }
            
            return imageView
        }
    }
    
    var coordinate: CLLocationCoordinate2D = .init()
    var type: EType = .startPoint
}

class MapViewController: UIViewController, MapViewControllerProtocol {
    var routeCoordinates: [CLLocationCoordinate2D] = []
    
    var mapPosAnnotation: MapCustomAnnotation = .init()
    var mapCurPosAnnotation: MapCustomAnnotation = .init()
    
    func clearRoute() {}
    
    func appendNewRoutePoint(location: CLLocationCoordinate2D) {
        routeCoordinates.append(location)
        let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(polyline)
        
        centerMap(location: location)
        mapView.removeAnnotation(mapCurPosAnnotation)
        mapCurPosAnnotation.coordinate = location
        mapView.addAnnotation(mapCurPosAnnotation)
    }
    
    func centerMap(location: CLLocationCoordinate2D) {
        let mRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(mRegion, animated: true)
    }
    
    func setStartPoint(location: CLLocationCoordinate2D) {
        mapView.removeAnnotation(mapPosAnnotation)
        centerMap(location: location)
        mapPosAnnotation.coordinate = location
        mapView.addAnnotation(mapPosAnnotation)

        routeCoordinates = [location]
    }
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .light
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        setMapConstraints()
        mapCurPosAnnotation.type = .currentPoint
    }
    
    func setMapConstraints() {
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 5
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let ant = annotation as? MapCustomAnnotation {
            let v = MKAnnotationView()
            v.image = ant.type.toImage()
            v.image?.withTintColor(.red, renderingMode: .alwaysOriginal)
            
            return v
        }
        
        return nil
    }
}


import SwiftUI

struct MapView: UIViewControllerRepresentable {
    var locations: [Location]
    
    typealias UIViewControllerType = MapViewController
    
    let vc: MapViewController?
    
    func makeUIViewController(context: Context) -> MapViewController {
        let vc = MapViewController()
        
        for (i, l) in locations.enumerated() {
            let loc = CLLocationCoordinate2D(latitude: l.latitude, longitude: l.longtitude)
            if i == 0 {
                vc.setStartPoint(location: loc)
            }
            else
            {
                vc.appendNewRoutePoint(location: loc)
            }
            
            if i == locations.count - 1 {
                vc.centerMap(location: loc)
            }
            
            
        }
        // Do some configurations here if needed.
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}
