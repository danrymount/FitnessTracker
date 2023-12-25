
import Foundation

protocol ActivitiesRepository
{
    func getActivities() -> [Date : [ActivityDataModel]]
    
    func getActivityById(id: Int) -> ActivityDataModel?
    
    func insertActivityData(data: ActivityDataModel)
}


class ActivitiesRepositoryImpl: ActivitiesRepository {
    static private(set) var shared = ActivitiesRepositoryImpl()
    
    // TODO store data by id, reduce complete reload
    private var activities: [Date:[ActivityDataModel]]? = nil
    
    func insertActivityData(data: ActivityDataModel) {
        CoreDataRepository.shared.insertActivityData(data: data)
        reloadAll()
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
    }
    
    func reloadAll()
    {
        var arr : [ActivityDataModel] = []
        for act in CoreDataRepository.shared.fetchActivities()
        {
            arr.append(ActivityDataModel.init(id: Int(act.id), performedAmount: act.amount, duration: act.duration , type: ActivityType(rawValue: Int(act.type)) ?? .Push_ups, datetime: act.date!))
        }
        arr.sort(by: {$0.datetime > $1.datetime})
        activities = Dictionary(grouping: arr, by: { Calendar.current.startOfDay(for: $0.datetime) })
    }
    
    func getActivities() -> [Date : [ActivityDataModel]] {
        if activities == nil
        {
            reloadAll()
        }
        
        
        return activities == nil ? [:] : activities!
    }
    
    func getActivityById(id: Int) -> ActivityDataModel? {
        for dateData in getActivities().values
        {
            for data in dateData
            {
                if data.id == id
                {
                    return data
                }
            }
        }
        
        return nil
    }
}
