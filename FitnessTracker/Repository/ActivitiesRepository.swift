
import Foundation


// TODO fill
enum ActionStatus {
    case success
    case error
}

protocol ActivitiesRepository {
    func getActivities() -> [ActivityDataModel]
    func getActivityById(id: Int) -> ActivityDataModel?
    
    // TODO return action status
    func createActivity(data: RunExerciseDataModel)
    func createActivity(data: SetsExerciseDataModel)
    
    func updateActivity(data: RunExerciseDataModel)
    func updateActivity(data: SetsExerciseDataModel)
    
    func deleteActivity(data: ActivityDataModel)
}


class ActivitiesRepositoryImpl: ActivitiesRepository {
    private(set) static var shared = ActivitiesRepositoryImpl()
    
    @Published public var activities: [Int64: ActivityDataModel] = [:]
    
    init() {
        var fetchedActivities = CoreDataRepository.shared.fetchActivities()
        if fetchedActivities.count == 0 {
            fillMockActivityData()
            fetchedActivities = CoreDataRepository.shared.fetchActivities()
        }
        
        activities = Dictionary(uniqueKeysWithValues: fetchedActivities.map { ($0.id, $0) })
    }
    
    func createActivity(data: RunExerciseDataModel) {
        if let res = CoreDataRepository.shared.insertExerciseData(data: data) {
            activities[res.id] = res
        }
    }
    
    func createActivity(data: SetsExerciseDataModel) {
        if let res = CoreDataRepository.shared.insertExerciseData(data: data) {
            activities[res.id] = res
        }
    }
    
    func updateActivity(data: RunExerciseDataModel) {
        CoreDataRepository.shared.updateRunExerciseData(data: data)
    }

    func updateActivity(data: ActivityDataModel) {
        
    }
    
    func getActivities() -> [ActivityDataModel] {
        return Array(activities.values)
    }
    
    func getActivityById(id: Int) -> ActivityDataModel? {
        if let activityData = activities[Int64(id)] {
            return activityData
        }
        
        return nil
    }
    
    func deleteActivity(id: Int) {
        if CoreDataRepository.shared.deleteActivity(id: Int64(id)) {
            activities.removeValue(forKey: Int64(id))
        }
    }
    
    func updateActivity(data: SetsExerciseDataModel) {
        
    }
    
    func deleteActivity(data: ActivityDataModel) {
        
    }
}


func fillMockActivityData() {
    
    // TODO fill mock data with location
    let data = [
        RunExerciseDataModel(id: 0, datetime: Date(timeIntervalSinceNow: -1*24*60*60), duration: 16*60, isCompleted: true, distance: 5.42, steps: -1, pace: -1, locations: []),
        RunExerciseDataModel(id: 0, datetime: Date(timeIntervalSinceNow: -4*24*60*60), duration: 3*60, isCompleted: true, distance: 0.5, steps: -1, pace: -1, locations: []),
        RunExerciseDataModel(id: 0, datetime: Date(timeIntervalSinceNow: -2*24*60*60), duration: 13*60+34, isCompleted: true, distance: 4.0, steps: -1, pace: -1, locations: []),
        RunExerciseDataModel(id: 0, datetime: Date(timeIntervalSinceNow: -30*24*60*60), duration: 8*60+40, isCompleted: true, distance: 1.5, steps: -1, pace: -1, locations: []),
        SetsExerciseDataModel(datetime: Date.now)
    ]
    
    
    for act in data {
        if act is RunExerciseDataModel {
            CoreDataRepository.shared.insertExerciseData(data: act as! RunExerciseDataModel)
        }
    }
}
