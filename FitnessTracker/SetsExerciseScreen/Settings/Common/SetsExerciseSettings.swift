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
    var repsArr: [UInt] {
        return [1,2,3]
    }
    
    var type: SetsExerciseType = .ladder
    
    
    var timeoutsArr: [TimeInterval] {
        [1,1]
    }
    
    var from: Int = 0
    var to: Int = 1
    var steps: Int = 1
    var timeout: TimeInterval = 0
}

final class SetsExerciseProgramSettings: SetsExerciseSettingsProtocol {
    var repsArr: [UInt] {
        [1,2,3]
    }
    
    var timeoutsArr: [TimeInterval] {
        [1,1]
    }
    
    var type: SetsExerciseType = .program
    
    var level: Int = -1
}

final class SetsExerciseCustomSettings: SetsExerciseSettingsProtocol {
    private(set) var repsArr: [UInt] = []
    
    private(set) var timeoutsArr: [TimeInterval] = []
    
    var type: SetsExerciseType = .custom
    
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
