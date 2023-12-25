
import Foundation

protocol ActivitiesRepository
{
    func getActivities() -> [Date : [ActivityDataModel]]
    
    func getActivityById(id: Int) -> ActivityDataModel?
}


class ActivitiesRepositoryImpl: ActivitiesRepository {
    
    static private(set) var shared = ActivitiesRepositoryImpl()
    
    private var activities: [Date:[ActivityDataModel]]? = [:]
    
    func getMockData() -> [ActivityDataModel]
    {
        return [.init(id: 1, performedAmount: 1, duration: TimeInterval(10), type: .Run, datetime: Date(timeIntervalSinceNow: TimeInterval(50))),
                .init(id: 2, performedAmount: 2, duration: TimeInterval(10), type: .Run, datetime: Date(timeIntervalSinceNow: TimeInterval(15*60*60))),
                .init(id: 3, performedAmount: 3, duration: TimeInterval(10), type: .Run, datetime: Date(timeIntervalSinceNow: TimeInterval(100*60*60))),
                .init(id: 4, performedAmount: 4, duration: TimeInterval(10), type: .Push_ups, datetime: Date(timeIntervalSinceNow: TimeInterval(50))),
                .init(id: 5, performedAmount: 5, duration: TimeInterval(10), type: .Push_ups, datetime: Date(timeIntervalSinceNow: TimeInterval(15*60*60))),
                .init(id: 6, performedAmount: 6, duration: TimeInterval(10), type: .Push_ups, datetime: Date(timeIntervalSinceNow: TimeInterval(100*60*60)))
        ]
    }
    
    func getActivities() -> [Date : [ActivityDataModel]] {
        if activities == nil
        {
            activities = Dictionary(grouping: self.getMockData(), by: { $0.datetime })
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
    
//    func loadActivities() -> [ActivityDataModel]{
//        var res : [ActivityDataModel] = []
//        
//        return [.init(id: 1, performedAmount: 1, duration: TimeInterval(10), type: .Run, datetime: Date(timeIntervalSinceNow: TimeInterval(50))),
//                .init(id: 2, performedAmount: 2, duration: TimeInterval(10), type: .Run, datetime: Date(timeIntervalSinceNow: TimeInterval(15*60*60))),
//                .init(id: 3, performedAmount: 3, duration: TimeInterval(10), type: .Run, datetime: Date(timeIntervalSinceNow: TimeInterval(100*60*60))),
//                .init(id: 4, performedAmount: 4, duration: TimeInterval(10), type: .Push_ups, datetime: Date(timeIntervalSinceNow: TimeInterval(50))),
//                .init(id: 5, performedAmount: 5, duration: TimeInterval(10), type: .Push_ups, datetime: Date(timeIntervalSinceNow: TimeInterval(15*60*60))),
//                .init(id: 6, performedAmount: 6, duration: TimeInterval(10), type: .Push_ups, datetime: Date(timeIntervalSinceNow: TimeInterval(100*60*60)))
//        ]
//        return res
//        
//    }
//    
//    func loadActivitiesData() -> [Date:[ActivityDataModel]]
//    {
//        let result : [Date:[ActivityDataModel]] = Dictionary(grouping: self.loadActivities(), by: { $0.datetime })
//        return result
//    }
}
