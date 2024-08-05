//

import Foundation

enum SetsExerciseType: String, CaseIterable {
    case ladder = "Ladder"
    case program = "Program"
    case custom = "Custom"
}

protocol SetsExerciseSettingsProtocol {
    var repsArr: [UInt] { get }
    var timeoutsArr: [TimeInterval] {get}
    
    var type: SetsExerciseType { get }
    
    init()
}

final class SetsExerciseLadderSettings: SetsExerciseSettingsProtocol {
    var type: SetsExerciseType = .ladder
    
    var repsArr: [UInt] {
        Array(stride(from: from, to: to + 1, by: UInt.Stride(steps)))
    }
    
    var timeoutsArr: [TimeInterval] {
        Array(repeating: timeout, count: repsArr.count)
    }
    
    var from: UInt = 0
    var to: UInt = 1
    var steps: UInt = 1
    var timeout: TimeInterval = 0
}

final class SetsExerciseProgramSettings: SetsExerciseSettingsProtocol {
    var repsArr: [UInt] {
        let levelsSteps: [Int: [UInt]] =
        [
            1:[1,2,3,4,5],
            2:[5,6,7,8,9],
            3:[10,11,12,13,14]
        ]
        
        return levelsSteps[level] ?? [10]
    }
    
    var timeoutsArr: [TimeInterval] {
        let levelsTimeout: [Int: TimeInterval] =
        [
            1:30,
            2:45,
            3:60
        ]
        return Array(repeating: levelsTimeout[level] ?? 0, count: repsArr.count)
    }
    
    var type: SetsExerciseType = .program
    
    var level: Int = -1
}

final class SetsExerciseCustomSettings: SetsExerciseSettingsProtocol {
    private(set) var repsArr: [UInt] = []
    
    private(set) var timeoutsArr: [TimeInterval] = []
    
    let type: SetsExerciseType = .custom
    
    var sets: Int = -1 {
        didSet {
            recal()
        }
    }
    var reps: Int = -1 {
        didSet {
            recal()
        }
    }
    var timeout: TimeInterval = -1 {
        didSet {
            recal()
        }
    }
    
    private func recal() {
        if sets <= 0 || timeout <= 0 {
            return
        }
        
        repsArr = Array(repeating: UInt(reps), count: sets)
        timeoutsArr = Array(repeating: timeout, count: sets - 1)
    }
}

class SetsExerciseSettings<T:SetsExerciseSettingsProtocol> {
    var exType: SetsExerciseType
    
    var settings: T
    
    init() {
        self.settings = T()
        self.exType = settings.type
    }
}
