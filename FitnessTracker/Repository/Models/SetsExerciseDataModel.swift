

import Foundation

class SetsExerciseDataModel: ActivityDataModel {

    override required init(datetime: Date) {
        super.init(datetime: datetime)
        self.type = .Push_ups
    }
    
    override var summary: String {
        "\(actualReps.reduce(0, +)) reps"
    }
    

    var actualReps: [UInt] = []
    var planReps: [UInt] = []
    
    var timeout: TimeInterval = 0
}
