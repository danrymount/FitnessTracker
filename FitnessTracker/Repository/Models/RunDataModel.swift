

import Foundation
import MapKit


class RunExerciseDataModel: ActivityDataModel {
    @Published var distance: Double = 0
    @Published var steps: Int64 = -1
    @Published var pace: Double = -1
    @Published var locations: [Location] = []

    required override init(datetime: Date) {
        super.init(datetime: datetime)
        self.type = .Run
        
    }
    
    init(id: Int64, datetime: Date, duration: TimeInterval, username: String? = nil, isCompleted: Bool, distance: Double, steps: Int64, pace: Double, locations: [Location]) {
        
        super.init(id: id, type: .Run, datetime: datetime, duration: duration, username: username, isCompleted: isCompleted)
        
        self.distance = distance
        self.steps = steps
        self.pace = pace
        self.locations = locations
        
    }
    
    override var summary: String {
        "\(distance) km."
    }
}
