//

import Foundation

struct SetsExerciseInfo {
    var type: SetsExerciseType
    var performedSets: [UInt]
    var startTime: Date

    mutating func addRep(_ val: UInt) {
        performedSets.append(val)
    }
}
