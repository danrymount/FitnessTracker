
import Foundation

protocol ActivitiesRepository {
    func getActivities() -> [ActivityDataModel]
    func getActivityById(id: Int) -> ActivityDataModel?
    
    func createActivity(data: RunExerciseDataModel)
    func createActivity(data: SetsExerciseDataModel)
    
//    func updateActivity(data: RunExerciseDataModel)
//    func updateActivity(data: SetsExerciseDataModel)
    
    func deleteActivity(id: Int)
}

class ActivitiesRepositoryImpl: ActivitiesRepository {

    
    private(set) static var shared = ActivitiesRepositoryImpl()
    
    @Published public var activities: [Int64: ActivityDataModel] = [:]
    
    init() {
        if CoreDataRepository.shared.fetchActivities().count == 0 {
            
            var ex1 = RunExerciseDataModel(datetime: Date(timeIntervalSinceNow: -TimeInterval(15*60*60)))
            ex1.isCompleted = true
            ex1.distance = 153
            
            CoreDataRepository.shared.insertExerciseData(data: ex1)
//            for act in getMockData() {
//                CoreDataRepository.shared.insertActivityData(data: act)
//            }
        }
        
        activities = Dictionary(uniqueKeysWithValues: CoreDataRepository.shared.fetchActivities().map { ($0.id, $0) })
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
}


func getMockActivityData() {
    
}
