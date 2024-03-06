

import Foundation
import MapKit


class RunExerciseDataModel: ActivityDataModel {

    required override init(datetime: Date) {
        super.init(datetime: datetime)
        self.type = .Run
        
    }
    
    override var summary: String {
        "\(distance) km."
    }
    
    var distance: Double = 0
    var steps: Int64 = -1
    var pace: Double = -1
    var locations: [CLLocation] = []
}
