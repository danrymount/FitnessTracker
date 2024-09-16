
import CoreData
import Foundation
import MapKit
import OSLog
import UIKit

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

    override private init() {
        super.init()
    }
    
    private var context: NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }
    
    func fetchActivities() -> [ActivityDataModel] {
        let allActivitiesRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ActivityDataEntityClass.entityName)
        let allRunExerciseRequest = NSFetchRequest<NSFetchRequestResult>(entityName: RunExerciseDataEntityClass.entityName)
        let allSetsExerciseRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SetsExerciseDataEntityClass.entityName)
        let allSetsExerciseCustomDataRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SetsExerciseCustomEntityClass.entityName)
        let allSetsExerciseLadderDataRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SetsExerciseLadderEntityClass.entityName)
        let allSetsExerciseProgramDataRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SetsExerciseProgramEntityClass.entityName)
        
        var result: [ActivityDataModel] = []
        do {
            let activities = try context.fetch(allActivitiesRequest) as! [ActivityDataEntityClass]
            
            let runExercises = try Dictionary(uniqueKeysWithValues: (context.fetch(allRunExerciseRequest) as! [RunExerciseDataEntityClass]).map { ($0.id, $0) })
            
            let setsExercises = try Dictionary(uniqueKeysWithValues: (context.fetch(allSetsExerciseRequest) as! [SetsExerciseDataEntityClass]).map { ($0.uid, $0) })
            
            let setsExercisesCustom = try Dictionary((context.fetch(allSetsExerciseCustomDataRequest) as! [SetsExerciseCustomEntityClass]).map { ($0.id, $0) }, uniquingKeysWith: {(first, _) in first})
            
            let setsExerciseLadder = try Dictionary((context.fetch(allSetsExerciseLadderDataRequest) as! [SetsExerciseLadderEntityClass]).map { ($0.id, $0) }, uniquingKeysWith: {(first, _) in first})
            
            let setsExerciseProgram = try Dictionary((context.fetch(allSetsExerciseProgramDataRequest) as! [SetsExerciseProgramEntityClass]).map { ($0.id, $0) }, uniquingKeysWith: {(first, _) in first})

            
            for act in activities {
                let actType = ActivityType(val: act.type)
                if actType == .Push_ups || actType == .Squats {
                    let newData = SetsExerciseDataModel(datetime: act.date ?? Date(timeIntervalSince1970: 0))
                    newData.type = actType
                    newData.duration = act.duration
                    newData.isCompleted = act.completed
                    newData.id = act.id
                    newData.actualReps = setsExercises[act.id]?.actualReps ?? []
                    var settingsId = setsExercises[act.id]?.settingsId ?? 0
                    if let custom = setsExercisesCustom[settingsId] {
                        newData.settings = SetsExerciseCustomSettings(custom)
                    } else if let ladder = setsExerciseLadder[settingsId] {
                        newData.settings = SetsExerciseLadderSettings(ladder)
                    } else if let program = setsExerciseProgram[settingsId] {
                        newData.settings = SetsExerciseProgramSettings(program)
                    }
                    
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
    
    private func getNextId<T: CustomEntityClass>(for obj: T) -> Int64 {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        let sort = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchLimit = 1
        
        do {
            let lastData = try context.fetch(fetchRequest)
            
            if lastData.count > 0, let data = (lastData[0] as? CustomEntityClass) {
                return data.uid + 1
            }
        } catch {
            print(error.localizedDescription)
        }
        return 0
    }
    
    private func insertEntity<EntityClass: CustomEntityClass>() -> EntityClass? {
        guard let dataEntityDesc = NSEntityDescription.entity(forEntityName: EntityClass.entityName, in: context)
        else {
            return nil
        }
        
        var new = EntityClass(entity: dataEntityDesc, insertInto: context)
        new.uid = getNextId(for: new)
        return new
    }
    
    private func fetchEntity<EntityClass: CustomEntityClass>(id: Int64) -> EntityClass? {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityClass.entityName)
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
        if let entity: ActivityDataEntityClass = insertEntity() {
            entity.date = data.datetime
            entity.type = Int16(data.type.rawValue)
            entity.duration = data.duration
            entity.username = data.username

            if saveContext() {
                data.id = entity.id
                return entity.id
            }
        }
        
        return -1
    }
    
    func insertExerciseData(data: RunExerciseDataModel) -> RunExerciseDataModel? {
        let newActivityId = insertActivityData(data: data)
        
        guard let entity: RunExerciseDataEntityClass = insertEntity() else {
            return nil
        }
        
        entity.id = newActivityId
        entity.distance = data.distance
        entity.steps = data.steps
        entity.pace = data.pace
        entity.cdLocations = ""
        
        if saveContext() {
            return data
        }
        
        return nil
    }
    
    func updateRunExerciseData(data: RunExerciseDataModel) -> RunExerciseDataModel? {
        let id = data.id
        let activityEntity: ActivityDataEntityClass? = fetchEntity(id: id)
        let runEntity: RunExerciseDataEntityClass? = fetchEntity(id: id)
        
        guard let activityEntity, let runEntity else {
            return nil
        }
        
        activityEntity.setValue(data.duration, forKey: "duration")
        runEntity.setValue(data.distance, forKey: "distance")
        runEntity.setValue(data.pace, forKey: "pace")
        runEntity.setValue(data.steps, forKey: "steps")
        runEntity.locations = data.locations

        saveContext()
        
        return nil
    }
    
    private func insertSettingsData(data: SetsExerciseSettingsProtocol) -> CustomEntityClass? {
        switch data.type {
        case .custom:
            if let entity: SetsExerciseCustomEntityClass = insertEntity() {
                entity.fill(data as! SetsExerciseCustomSettings)
                return entity
            }
        case .ladder:
            if let entity: SetsExerciseLadderEntityClass = insertEntity() {
                entity.fill(data as! SetsExerciseLadderSettings)
                return entity
            }
        case .program:
            if let entity: SetsExerciseProgramEntityClass = insertEntity() {
                entity.fill(data as! SetsExerciseProgramSettings)
                return entity
            }
        }
        
        return nil
    }
    
    func insertExerciseData(data: SetsExerciseDataModel) -> SetsExerciseDataModel? {
        let newActivityId = insertActivityData(data: data)
        
        guard let settings = data.settings else {
            return nil
        }
        
        guard let entity: SetsExerciseDataEntityClass = insertEntity() else {
            return nil
        }
        guard let settingsEntity = insertSettingsData(data: settings) else {
            return nil
        }
        
        entity.id = newActivityId
        entity.settingsId = settingsEntity.uid
        entity.actualReps = data.actualReps

        if saveContext() {
            data.id = newActivityId
            return data
        }
        
        return nil
    }
}
