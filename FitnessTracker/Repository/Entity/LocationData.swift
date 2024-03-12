
import Foundation
import MapKit


public class Location: Codable {
    public var latitude: CLLocationDegrees = 0
    public var longtitude: CLLocationDegrees = 0
    public var timestamp: Date = Date.now
    
    init(location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longtitude = location.coordinate.latitude
        self.timestamp = location.timestamp
    }
    
    init(latitude: Double, longitude: Double, time: Date) {
        self.latitude = latitude
        self.longtitude = longitude
        self.timestamp = time
    }
}

extension RunExerciseDataEntityClass {
    var locations : [Location] {
        get {
           return (try? JSONDecoder().decode([Location].self, from: Data((cdLocations ?? "").utf8))) ?? []
        }
        set {
           do {
               let reminderData = try JSONEncoder().encode(newValue)
               cdLocations = String(data: reminderData, encoding:.utf8)!
           } catch { cdLocations = "" }
        }
    }
}
