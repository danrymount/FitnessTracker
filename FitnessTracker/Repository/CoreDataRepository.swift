
import CoreData
import Foundation
import OSLog
import UIKit
import MapKit



private func log(message: String) {
    let msg = "[CoreDataRepository] " + message
    Logger().info("\(msg)")
}

protocol CoreDataRepositoryProtocol {
    func fetchActivities() -> [ActivityDataModel]
    func fetchActivity(id: Int64) -> ActivityDataModel?
    
    func insertExerciseData(data: RunExerciseDataModel) -> RunExerciseDataModel?
    func insertExerciseData(data: SetsExerciseDataModel) -> SetsExerciseDataModel?
    
    func updateRunExerciseData(data: RunExerciseDataModel) -> RunExerciseDataModel?
    func updateSetsExerciseData(data: SetsExerciseDataModel) -> SetsExerciseDataModel?
    
    func deleteActivity(id: Int64) -> Bool
    
    func commit() -> Bool
}

class CoreDataRepository: NSObject, CoreDataRepositoryProtocol {
    public static let shared = CoreDataRepository()
    var lastId: Int64 = 0

    override private init() {
        super.init()
        lastId = getLastId()
    }
    
    private var context: NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }
    
    func fetchActivities() -> [ActivityDataModel] {
        let allActivitiesRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ActivityData")
        let allRunExerciseRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RunExerciseData")
        let allSetsExerciseRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SetsExerciseData")
        var result: [ActivityDataModel] = []
        do {
            let activities = try context.fetch(allActivitiesRequest) as! [ActivityDataEntityClass]
            
            let runExercises = try Dictionary(uniqueKeysWithValues: (context.fetch(allRunExerciseRequest) as! [RunExerciseDataEntityClass]).map { ($0.id, $0) })
            
            let setsExercises = try Dictionary(uniqueKeysWithValues: (context.fetch(allSetsExerciseRequest) as! [SetsExerciseDataEntityClass]).map { ($0.id, $0) })
            
            for act in activities {
                let actType = ActivityType(val: act.type)
                if actType == .Push_ups || actType == .Squats {
                    let newData = SetsExerciseDataModel(datetime: act.date ?? Date(timeIntervalSince1970: 0))
                    newData.type = actType
                    newData.duration = act.duration
                    newData.isCompleted = act.completed
                    newData.id = act.id
                    newData.actualReps = setsExercises[act.id]?.actualReps ?? []
                    newData.planReps = setsExercises[act.id]?.planReps ?? []
                    
                    result.append(newData)
                } else if actType == .Run {
                    let newData = RunExerciseDataModel(datetime: act.date ?? Date(timeIntervalSince1970: 0))
                    newData.duration = act.duration
                    newData.isCompleted = act.completed
                    newData.id = act.id
                    newData.distance = runExercises[act.id]?.distance ?? -1
                    newData.pace = runExercises[act.id]?.pace ?? -1
                    newData.steps = runExercises[act.id]?.steps ?? -1
                    newData.locations = runExercises[act.id]?.locations ?? []
                    
                    result.append(newData)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }
    
    func fetchActivity(id: Int64) -> ActivityDataModel? {
        return nil
    }
    
    func updateSetsExerciseData(data: SetsExerciseDataModel) -> SetsExerciseDataModel? {
        nil
    }
    
    func deleteActivity(id: Int64) -> Bool {
        let activityEntity: ActivityDataEntityClass? = fetchEntity(id: id)
        
        let runEntity: RunExerciseDataEntityClass? = fetchEntity(id: id)
        let setsEntity: SetsExerciseDataEntityClass? = fetchEntity(id: id)
        
        if let activityEntity {
            context.delete(activityEntity)
        }
        
        if let runEntity {
            context.delete(runEntity)
        }
        
        if let setsEntity {
            context.delete(setsEntity)
        }
        
        return saveContext()
    }
    
    func commit() -> Bool {
        false
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ActivityData")
        let sort = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchLimit = 1
        
        do {
            let lastData = try context.fetch(fetchRequest)
            
            if lastData.count > 0 {
                return (lastData[0] as! ActivityDataEntityClass).id
            }
        } catch {
            print(error.localizedDescription)
        }
        return 0
    }
    
    private func insertEntity<EntityClass>() -> EntityClass? {
        let entityName: String = {
            if EntityClass.self == ActivityDataEntityClass.self {
                return "ActivityData"
            } else if EntityClass.self == RunExerciseDataEntityClass.self {
                return "RunExerciseData"
            } else if EntityClass.self == SetsExerciseDataEntityClass.self {
                return "SetsExerciseData"
            } else {
                fatalError("Incorrect entity class")
            }
        }()
        
        guard let dataEntityDesc = NSEntityDescription.entity(forEntityName: entityName, in: context)
        else {
            return nil
        }
        
        if EntityClass.self == ActivityDataEntityClass.self {
            return ActivityDataEntityClass(entity: dataEntityDesc, insertInto: context) as? EntityClass
        } else if EntityClass.self == RunExerciseDataEntityClass.self {
            return RunExerciseDataEntityClass(entity: dataEntityDesc, insertInto: context) as? EntityClass
        } else if EntityClass.self == SetsExerciseDataEntityClass.self {
            return SetsExerciseDataEntityClass(entity: dataEntityDesc, insertInto: context) as? EntityClass
        }
        
        return nil
    }
    
    private func fetchEntity<EntityClass>(id: Int64) -> EntityClass? {
        do {
            let entityName: String = {
                if EntityClass.self == ActivityDataEntityClass.self {
                    return "ActivityData"
                } else if EntityClass.self == RunExerciseDataEntityClass.self {
                    return "RunExerciseData"
                } else if EntityClass.self == SetsExerciseDataEntityClass.self {
                    return "SetsExerciseData"
                } else {
                    fatalError("Incorrect entity class")
                }
            }()
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(
                format: "id == %@", String(id)
            )
        
            let result = try context.fetch(fetchRequest)
        
            for obj in result {
                return (obj as? EntityClass)
            }
        } catch {
            Logger().info("\(error.localizedDescription)")
//            log(error.localizedDescription)
        }
        
        return nil
    }
    
    func insertActivityData(data: ActivityDataModel) -> Int64 {
        let id = Int64(lastId + 1)
        
        if let entity: ActivityDataEntityClass = insertEntity() {
            entity.id = id
            entity.date = data.datetime
            entity.type = Int16(data.type.rawValue)
            entity.duration = data.duration
            entity.username = data.username

            if saveContext() {
                lastId += 1
            }
        } else {
            return -1
        }
        
        return id
    }
    
    func insertExerciseData(data: RunExerciseDataModel) -> RunExerciseDataModel? {
        let newActivityId = insertActivityData(data: data)
        data.id = newActivityId
        if let entity: RunExerciseDataEntityClass = insertEntity() {
            entity.id = newActivityId
            entity.distance = data.distance
            entity.steps = data.steps
            entity.pace = data.pace
            entity.cdLocations = ""
            
            if saveContext() {
                return data
            }
        }
        
        return nil
    }
    
    func updateRunExerciseData(data: RunExerciseDataModel) -> RunExerciseDataModel? {
        let id = data.id
        let activityEntity: ActivityDataEntityClass? = fetchEntity(id: id)
        let runEntity: RunExerciseDataEntityClass? = fetchEntity(id: id)
        
        if activityEntity != nil && runEntity != nil {
            activityEntity?.setValue(data.duration, forKey: "duration")
            
            runEntity?.setValue(data.distance, forKey: "distance")
            runEntity?.setValue(data.pace, forKey: "pace")
            runEntity?.setValue(data.steps, forKey: "steps")
            runEntity?.locations = data.locations

            saveContext()
        }
        
        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RunExerciseData")
//        fetchRequest.predicate = NSPredicate(
//            format: "id == %@", String(id)
//        )
//        do {
//            let result = try context.fetch(fetchRequest)
//        
//            runEntity?.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
//            for obj in result {
//                return (obj as? EntityClass)
//            }
//            
//            runEntity?.distance = 5
//            
//            saveContext()
//        }
//        catch {
//            
//        }
        
//        saveContext()
        return nil
    }
    
    func insertExerciseData(data: SetsExerciseDataModel) -> SetsExerciseDataModel? {
        let newActivityId = insertActivityData(data: data)

        if let entity: SetsExerciseDataEntityClass = insertEntity() {
            entity.id = newActivityId
            entity.planReps = data.planReps
            entity.actualReps = data.actualReps
            
            if saveContext() {
                return data
            }
        }
        
        return nil
    }
}
