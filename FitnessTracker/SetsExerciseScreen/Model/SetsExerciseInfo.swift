//

import Foundation

struct SetsExerciseInfo {
    var type: SetsExerciseType
    var performedReps: [UInt]
    var startTime: Date
    
    mutating func addRep(_ val: UInt) {
        performedReps.append(val)
    }
}
