

import Foundation

class SetsExerciseDataModel: ActivityDataModel {

    required override init(datetime: Date) {
        super.init(datetime: datetime)
        self.type = type
    }
    
    override var summary: String {
        "\(actualReps.reduce(0, +)) reps"
    }

    var actualReps: [UInt] = []
    var planReps: [UInt] {
        get {
            return settings?.repsArr ?? []
        }
    }
    
    var timeout: TimeInterval = 0
    
    var settings: SetsExerciseSettingsProtocol?
}
