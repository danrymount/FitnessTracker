

import Foundation
import MapKit


class RunExerciseDataModel: ActivityDataModelProtocol {
    var id: Int64 = -1
    var type: ActivityType = .Run
    var datetime: Date
    var duration: TimeInterval = 0
    var username: String?
    var isCompleted: Bool = false

    required init(datetime: Date) {
        self.datetime = datetime
    }
    
    var summary: String {
        "\(distance) km."
    }
    
    var distance: Double = 0
    var steps: Int64 = -1
    var pace: Double = -1
    var locations: [CLLocation] = []
}
