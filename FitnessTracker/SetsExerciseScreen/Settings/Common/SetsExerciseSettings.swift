//

import Foundation

enum SetsExerciseType: String, CaseIterable {
    case ladder = "Ladder"
    case program = "Program"
    case custom = "Custom"
}

protocol SetsExerciseSettingsProtocol {
    var repsArr: [UInt] { get }
    var timeoutsArr: [TimeInterval] { get }
    
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
    private static var programInfo: [([UInt], [TimeInterval])] = [
        ([1, 2, 3, 4, 5], [30, 30, 30, 30]),
        ([5, 6, 7, 8, 9], [45, 45, 45, 45]),
        ([10, 11, 12, 13, 14], [60, 60, 60, 60])
    ]
    
    static var maxLevel: Int = programInfo.count
    
    var repsArr: [UInt] {
        return SetsExerciseProgramSettings.programInfo[level - 1].0
    }
    
    var timeoutsArr: [TimeInterval] {
        return SetsExerciseProgramSettings.programInfo[level - 1].1
    }
    
    var type: SetsExerciseType = .program
    
    var level: Int = 1 {
        didSet {
            assert(level >= 1 && level <= SetsExerciseProgramSettings.maxLevel, "Level is out of range")
        }
    }
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

class SetsExerciseSettings<T: SetsExerciseSettingsProtocol> {
    var exType: SetsExerciseType
    
    var settings: T
    
    init() {
        self.settings = T()
        self.exType = settings.type
    }
}
