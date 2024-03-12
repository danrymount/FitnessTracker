
import Foundation
import CoreLocation


struct RunRouteDataModel
{
    var totalDistance: Double = 0
    var routeCoordinates: [CLLocation] = [] {
        didSet {
            if routeCoordinates.count < 2 {
                return
            }
            
            totalDistance += Double(routeCoordinates.last?.distance(from: routeCoordinates[routeCoordinates.count - 2]) ?? 0).rounded()
        }
    }
}
