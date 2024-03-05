
import CoreData
import Foundation
import UIKit
import OSLog

fileprivate func log(message: String) {
    var msg = "[CoreDataRepository] " + message
    Logger().info("\(msg)")
}

public final class CoreDataRepository: NSObject {
    public static let shared = CoreDataRepository()
    var lastId: Int64
    override private init() {
        lastId = 0
        super.init()
        lastId = getLastId()
    }
    
    private var context: NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }
    
    private func saveContext() -> Bool {
        do {
            try context.save()
        } catch {
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
            
            if lastData.count > 0 {
                return (lastData[0] as! ActivityEntityClass).id
            }
        } catch {
            print(error.localizedDescription)
        }
        return 0
    }
    
    func insertRunActivityData(data: RunExerciseDataModel) -> Int64 {
        let newActivityId = insertActivityData(data: data)
        
        guard let runDataEntityDesc = NSEntityDescription.entity(forEntityName: "RunData", in: context)
        else {
            return -1
        }
        let d = RunDataEntityClass(entity: runDataEntityDesc, insertInto: context)
        d.id = newActivityId
        d.distance = data.distance
        d.pace = data.pace
        // TODO fill locations
        
        if saveContext() {
            // TODO handle
        }
        
        return newActivityId
    }
    
    func insertActivityData(data: ActivityDataModelProtocol) -> Int64 {
        guard let activityEntityDescription = NSEntityDescription.entity(forEntityName: "Activity", in: context)
        else {
            return -1
        }
        let d = ActivityEntityClass(entity: activityEntityDescription, insertInto: context)
        d.id = Int64(lastId + 1)
        d.date = data.datetime
        d.type = Int16(data.type.rawValue)
        d.duration = data.duration
        d.username = data.username

        if saveContext() {
            lastId += 1
        }
        
        return d.id
    }
    
    
    
    public func insertActivityData(data: ActivityDataModel) -> Int64 {
        guard let activityEntityDescription = NSEntityDescription.entity(forEntityName: "Activity", in: context)
        else {
            return -1
        }
        let d = ActivityEntityClass(entity: activityEntityDescription, insertInto: context)
        d.id = Int64(lastId + 1)
        d.amount = Double(data.performedAmount)
        d.date = data.datetime
        d.type = Int16(data.type.rawValue)
        d.duration = data.duration
        d.username = data.username

        if saveContext() {
            lastId += 1
        }
        
        return d.id
    }
    
    public func fetchActivities() -> [ActivityEntityClass] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        do {
            return try context.fetch(fetchRequest) as! [ActivityEntityClass]
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    public func fetchActivity(uid: Int) -> ActivityEntityClass? {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
            fetchRequest.predicate = NSPredicate(
                format: "id == %@", String(uid)
            )
            
            let result = try context.fetch(fetchRequest)
            
            for obj in result {
                return (obj as! ActivityEntityClass)
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    public func deleteActivity(uid: Int) {
        if let act = fetchActivity(uid: uid) {
            log(message: "Delete activity \(uid)")
            context.delete(act)
            saveContext()
        }
    }
}
