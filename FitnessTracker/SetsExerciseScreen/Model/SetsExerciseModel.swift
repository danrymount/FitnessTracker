//

import Foundation

class SetsExerciseViewModel {
    let activityType: ActivityType
    var info: SetsExerciseInfo?
    var settings: SetsExerciseSettingsProtocol? {
        didSet {
            guard let settings = settings else {
                return
            }
            info = SetsExerciseInfo(type: settings.type, performedSets: [], startTime: Date(timeIntervalSinceNow: 0))
        }
    }

    var duration: TimeInterval {
        guard let info = info else {
            return 0
        }
        return Date(timeIntervalSinceNow: 0) - info.startTime
    }
    
    var allRepsArr: [UInt] {
        guard let settings = settings else {
            return []
        }
            
        return settings.repsArr
    }
    
    var performedReps: Int {
        guard let info = info else {
            return 0
        }
        
        return Int(info.performedSets.reduce(UInt(0), +))
    }
    
    var completedSets: Int {
        guard let info = info else {
            return 0
        }
            
        return info.performedSets.count
    }
    
    var isLastSet: Bool {
        return allRepsArr.count == completedSets - 1
    }
    
    var isCompleted: Bool {
        return allRepsArr.count == completedSets
    }
    
    var currentReps: UInt {
        return allRepsArr.count > 0 ? allRepsArr[completedSets] : 0
    }
    
    var currentTimeout: TimeInterval {
        guard let settings = settings else {
            return 0
        }
            
        return settings.timeoutsArr[completedSets - 1]
    }
    
    init(activityType: ActivityType) {
        self.activityType = activityType
    }
    
    func setDone() {
        if let planReps = settings?.repsArr, let info = self.info {
            self.info?.addRep(planReps[info.performedSets.count])
        }
    }
    
    func save() {
        if var info = info {
            let exerciseDuration: TimeInterval = Date(timeIntervalSinceNow: 0) - info.startTime
            let dataModel = SetsExerciseDataModel(datetime: Date(timeIntervalSinceNow: exerciseDuration))
            dataModel.settings = settings
            dataModel.type = self.activityType
            dataModel.duration = exerciseDuration
            dataModel.actualReps = info.performedSets
            ActivitiesRepositoryImpl.shared.createActivity(data: dataModel)
        }
    }
}

private extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
