

import Foundation
import UIKit
import MapKit

protocol MapViewControllerProtocol {
    func clearRoute();
    func appendNewRoutePoint(location: CLLocationCoordinate2D);
    func setStartPoint(location: CLLocationCoordinate2D);
}

class MapCustomAnnotation: NSObject, MKAnnotation {
    enum EType {
        case startPoint
        case currentPoint
        
        func toImage() -> UIImage? {
            var imgName = "mappin.and.ellipse"
            switch self
            {
                case .startPoint:
                    imgName = "mappin.and.ellipse"
                case .currentPoint:
                    imgName = "mappin.and.ellipse"
            }
            
            return UIImage(systemName: imgName)
        }
    }
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var type: EType = .startPoint
}

class MapViewController : UIViewController, MapViewControllerProtocol {
    var routeCoordinates : [CLLocationCoordinate2D] = []
    
    var mapPosAnnotation: MapCustomAnnotation = MapCustomAnnotation()
    //    var mapCurPosAnnotation: MKPointAnnotation = MKPointAnnotation()
    
    func clearRoute() {
        
    }
    
    func appendNewRoutePoint(location: CLLocationCoordinate2D) {
        //        routeCoordinates.append(location)
        //
        //        let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
        //        mapView.removeOverlays(mapView.overlays)
        //        mapView.addOverlay(polyline)
        //        var l1 = CLLocation(latitude: routeCoordinates.last!.latitude, longitude: routeCoordinates.last!.longitude)
        //        var l2 = CLLocation(latitude: routeCoordinates[routeCoordinates.count-2].latitude, longitude:
        //                                routeCoordinates[routeCoordinates.count-2].longitude)
        ////        runRouteData.distance += l1.distance(from: l2)
        //
        //        centerMap(location: location)
        //        print(mapView.overlays.count)
    }
    
    func centerMap(location: CLLocationCoordinate2D)
    {
        let mRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(mRegion, animated: true)
    }
    
    func setStartPoint(location: CLLocationCoordinate2D) {
        centerMap(location: location)
        mapPosAnnotation.coordinate = location
        
        routeCoordinates.append(location)
        let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(polyline)
    }
    
    let mapView : MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .light
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        setMapConstraints()
        mapView.addAnnotation(mapPosAnnotation)
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


extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 7
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let ant = annotation as? MapCustomAnnotation {
            let v = MKAnnotationView()
            v.image = ant.type.toImage()
            
            return v
        }
        
        return nil
    }
}
