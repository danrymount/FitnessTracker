

import Foundation

class ActivityDetailsViewModel: ObservableObject {

    private var activityId: Int
    @Published var activityData: ActivityDataModel? = nil

    init(activityId: Int)
    {
        self.activityId = activityId
    }
    
    func loadData()
    {
        activityData = ActivitiesRepositoryImpl.shared.getActivityById(id: activityId)
    }
    
    func deleteData()
    {
        ActivitiesRepositoryImpl.shared.deleteActivity(id: activityId)
    }
}
