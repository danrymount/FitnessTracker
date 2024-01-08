
import Foundation

class ActivitiesListViewModel : ObservableObject{
    @Published var activities: [Date:[ActivityDataModel]] = [:]
    let dataType: ActivityListType
    
    init(activityListType: ActivityListType) {
        dataType = activityListType
        loadData()
    }
    func loadData()
    {
        if dataType == .myActivities
        {
            // TODO observe activities changes in repository in order to prevent force reloading
            var allActivities = ActivitiesRepositoryImpl.shared.getActivities()

            allActivities.sort(by: {$0.datetime > $1.datetime})
            activities = Dictionary(grouping: allActivities, by: { Calendar.current.startOfDay(for: $0.datetime) })
        }
        else
        {
            // TODO implement getting other users acitivities
        }
    }
}
