//

import Foundation

class SetsExerciseViewModel {
    let activityType: ActivityType
    var info: SetsExerciseInfo?
    var settings: SetsExerciseSettingsProtocol? = nil {
        didSet {
            guard let settings = settings else {
                return
            }
            info = SetsExerciseInfo(type: settings.type, performedReps: [], startTime: Date(timeIntervalSinceNow: 0))
        }
    }
    var duration: TimeInterval {
        get {
            guard let info = info else {
                return 0
            }
            return Date(timeIntervalSinceNow: 0) - info.startTime
        }
    }
    
    var allRepsArr: [UInt] {
        get {
            guard let settings = settings else {
                return []
            }
            
            return settings.repsArr
        }
    }
    
    var completedReps: Int {
        get {
            guard let info = info else {
                return 0
            }
            
            return info.performedReps.count
        }
    }
    
    var isLastSet: Bool {
        get {
            return allRepsArr.count == completedReps - 1
        }
    }
    
    var isCompleted: Bool {
        get {
            return allRepsArr.count == completedReps
        }
    }
    
    var currentReps: UInt {
        get {
            return allRepsArr.count > 0 ? allRepsArr[completedReps] : 0
        }
    }
    
    var currentTimeout: TimeInterval {
        get {
            guard let settings = settings else {
                return 0
            }
            
            return settings.timeoutsArr[completedReps]
        }
    }
    
    init(activityType: ActivityType) {
        self.activityType = activityType
    }
    
    func setDone() {
        if let planReps = settings?.repsArr, var info = self.info {
            self.info?.addRep(planReps[info.performedReps.count])
        }
    }
    
    
    
    func save() {
        if var info = info {
//            let exerciseDuration: TimeInterval = Date(timeIntervalSinceNow: 0) - info.startTime
            
//            let dataModel = SetsExerciseDataModel(datetime: Date.init(timeIntervalSinceNow: exerciseDuration))
//            dataModel.planReps = Array(0..<self.settings.sets.value).map( { _ in self.settings.repeats.value})
//            dataModel.actualReps = Array(0..<self.exerciseInfo.completedSets).map( { _ in self.settings.repeats.value})
//            dataModel.type = self.activityType
//            dataModel.duration = exerciseDuration
//            ActivitiesRepositoryImpl.shared.createActivity(data: dataModel)
        }
    }
}

fileprivate extension Date {
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
}
