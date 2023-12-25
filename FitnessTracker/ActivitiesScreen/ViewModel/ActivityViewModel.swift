
import Foundation

class ActivitiesListViewModel : ObservableObject{
    @Published var activities: [Date:[ActivityDataModel]] = ActivitiesRepositoryImpl.shared.getActivities()
    
    // TODO Correct observing
    public func reload()
    {
        activities = ActivitiesRepositoryImpl.shared.getActivities()
    }
}
