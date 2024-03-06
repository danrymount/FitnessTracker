
import Foundation
import CoreLocation


protocol ExerciseLocationDelegate {
    func onChangeLocation(locations: [CLLocation])
    func onChangeStatus(status: CLAuthorizationStatus)
}

protocol ExerciseLocationManagerProtocol {
    var locationDelegate: ExerciseLocationDelegate? { get set }

    func configure()
    func start()
    func stop()
    func getCurrentLocation()
}

class ExerciseLocationManager: NSObject, CLLocationManagerDelegate, ExerciseLocationManagerProtocol {
    func getCurrentLocation() {
        locationManager.requestLocation()
    }
    
    var locationDelegate: ExerciseLocationDelegate?
    var locationManager: CLLocationManager!
    
    func configure() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 10
        locationManager.delegate = self
    }
    
    func start() {
//        locationManager.startUpdatingLocation()
    }
    
    func stop() {
//        locationManager.stopUpdatingLocation()
    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        locationDelegate?.onChangeLocation(locations: locations)
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        locationDelegate?.onChangeStatus(status: status)
        // Check accuracy authorization
        let accuracy = manager.accuracyAuthorization
        switch accuracy {
        case .fullAccuracy:
            print("Location accuracy is precise.")
        case .reducedAccuracy:
            print("Location accuracy is not precise.")
        @unknown default:
            fatalError()
        }
        
        // Handle authorization status
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            fatalError()
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}




class DummyExerciseLocationManager: ExerciseLocationManagerProtocol {
    var locationDelegate: ExerciseLocationDelegate?
    private var lastLocation = CLLocationCoordinate2D(latitude: 43.253173, longitude: 76.92095)
    
    func configure() {
        locationDelegate?.onChangeStatus(status: .authorizedAlways)
    }
    
    func start() {
        
    }
    
    func stop() {
        
    }
    
    func getCurrentLocation() {
        let newLat = lastLocation.latitude + Double(Int.random(in: 0...10))/50000 * Double(Int.random(in: 0...1))
        let newLong = lastLocation.longitude + Double(Int.random(in: 0...10))/50000
        let newCoord = CLLocation(latitude: newLat, longitude: newLong)
        
        locationDelegate?.onChangeLocation(locations: [newCoord])
        
        lastLocation = newCoord.coordinate
    }
    
    
}
