
import Foundation
import UIKit
import CoreData

public final class CoreDataRepository: NSObject {
    public static let shared = CoreDataRepository()
    var lastId: Int64
    private override init() {
        lastId = 0
        super.init()
        lastId = getLastId()
    }
    
    private var context: NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }
    
    private func saveContext() -> Bool {
        do
        {
            try context.save()
        }
        catch{
            print(error.localizedDescription)
            return false
        }
        
        return true
    }
    
    private func getLastId() -> Int64 {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        let sort = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchLimit = 1
        
        do {
            let lastData = try context.fetch(fetchRequest)
            
            if lastData.count > 0
            {
                return (lastData[0] as! ActivityEntityClass).id
            }
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
        d.id = Int64(lastId + 1)
        d.amount = Double(data.performedAmount)
        d.date = data.datetime
        d.type = Int16(data.type.rawValue)
        d.duration = data.duration
        d.username = data.username

        
        if saveContext()
        {
            lastId += 1
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
    
    public func fetchActivity(uid: Int) -> ActivityEntityClass?
    {
        do {
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
    
    public func deleteActivity(uid: Int)
    {
        if let act = fetchActivity(uid: uid)
        {
            print("delete")
            context.delete(act)
            saveContext()
        }
    }
}
