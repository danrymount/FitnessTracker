
import Foundation
import UIKit
import CoreData

public final class CoreDataRepository: NSObject {
    public static let shared = CoreDataRepository()
    var lastId: UInt64
    private override init() {
        lastId = 0
        super.init()
        lastId = getLastId()
        print(lastId)
    }
    
//    private var appDelegate: FitnessTrackerApp {
//        FitnessTrackerApp.instance
//    }
    
    private var context: NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }
    
    private func getLastId() -> UInt64 {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        do {
                let count = try context.count(for: fetchRequest)
                return UInt64(count)
            } catch {
                print(error.localizedDescription)
            }
        return 0
    }
    
    public func insertActivityData(data:ActivityDataModel)
    {
        guard let activityEntityDescription = NSEntityDescription.entity(forEntityName: "Activity", in: context)
        else {
            return
        }

        let d = ActivityEntityClass(entity: activityEntityDescription, insertInto: context)
        d.id = Int64(lastId)
        d.amount = Double(data.performedAmount)
        d.date = data.datetime
        d.type = Int16(data.type.rawValue)
        d.duration = data.duration
        d.username = "empty"
        
        do
        {
            try context.save()
            lastId += 1
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    public func fetchActivities() -> [ActivityEntityClass]
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        do
        {
            return try context.fetch(fetchRequest) as! [ActivityEntityClass]
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    public func fetchActivity(uid: UInt) -> ActivityEntityClass?
    {
        do
        {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
            fetchRequest.predicate = NSPredicate(
                format: "id == %@", String(uid)
            )
            
            let result = try context.fetch(fetchRequest)
            
            for obj in result {
                return (obj as! ActivityEntityClass)
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
