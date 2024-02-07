

import Foundation

struct RunMotionDataModel {
    var distance: Double?
    var avgPace: Double?
    var steps: UInt64 = 0
    
    func getPaceStr() -> String {
        if avgPace != nil {
            return "\(avgPace!) min/km"
        }
        
        return "--/-- min/km"
    }
    
    func getDistanceStr() -> String {
        if distance != nil {
            return "\(distance!) m."
        }
        
        return "-- m."
    }
    
    func getStepsStr() -> String {
        return "\(steps) steps"
    }
}
