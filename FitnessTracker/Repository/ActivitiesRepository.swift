
import Foundation

protocol ActivitiesRepository
{
    func getActivities() -> [ActivityDataModel]
    
    func getActivityById(id: Int) -> ActivityDataModel?
    
    func insertActivityData(data: ActivityDataModel)
    
    func deleteActivity(id: Int)
}


class ActivitiesRepositoryImpl: ActivitiesRepository {
    static private(set) var shared = ActivitiesRepositoryImpl()
    
    // TODO store data by id, reduce complete reload
    @Published public var activities: [ActivityDataModel.ID : ActivityDataModel] = [:]
    
    func insertActivityData(data: ActivityDataModel) {
        CoreDataRepository.shared.insertActivityData(data: data)
        
        if let act = CoreDataRepository.shared.fetchActivity(uid: Int(CoreDataRepository.shared.lastId))
        {
            print(act)
            activities[ActivityDataModel.ID(act.id)] = ActivityDataModel.init(id: Int(act.id), performedAmount: act.amount, duration: act.duration , type: ActivityType(rawValue: Int(act.type)) ?? .Push_ups, datetime: act.date!)
        }
    }
    
    func getMockData() -> [ActivityDataModel]
    {
        return [.init(id: 1, performedAmount: 1, duration: TimeInterval(10), type: .Run, datetime: Date(timeIntervalSinceNow: -TimeInterval(50))),
                .init(id: 2, performedAmount: 2, duration: TimeInterval(10), type: .Run, datetime: Date(timeIntervalSinceNow: -TimeInterval(15*60*60))),
                .init(id: 3, performedAmount: 3, duration: TimeInterval(10), type: .Run, datetime: Date(timeIntervalSinceNow: -TimeInterval(100*60*60))),
                .init(id: 4, performedAmount: 4, duration: TimeInterval(10), type: .Push_ups, datetime: Date(timeIntervalSinceNow: -TimeInterval(50))),
                .init(id: 5, performedAmount: 5, duration: TimeInterval(10), type: .Push_ups, datetime: Date(timeIntervalSinceNow: -TimeInterval(15*60*60))),
                .init(id: 6, performedAmount: 6, duration: TimeInterval(10), type: .Push_ups, datetime: Date(timeIntervalSinceNow: -TimeInterval(100*60*60)))
        ]
    }
    
    init()
    {
        if CoreDataRepository.shared.fetchActivities().count == 0
        {
            for act in getMockData()
            {
                CoreDataRepository.shared.insertActivityData(data: act)
            }
        }
        
        for act in CoreDataRepository.shared.fetchActivities()
        {
            activities[ActivityDataModel.ID(act.id)] = ActivityDataModel.init(id: Int(act.id), performedAmount: act.amount, duration: act.duration , type: ActivityType(rawValue: Int(act.type)) ?? .Push_ups, datetime: act.date!)
        }
    }
    
    func getActivities() -> [ActivityDataModel] {
        return Array(activities.values)
    }
    
    func getActivityById(id: Int) -> ActivityDataModel? {
        if let activityData = activities[id]
        {
            return activityData
        }
        
        return nil
    }
    
    func deleteActivity(id: Int) {
        CoreDataRepository.shared.deleteActivity(uid: id)
        activities[id] = nil
    }
}
