

import CoreData
import Foundation


protocol CustomEntityClass: NSManagedObject {
    var uid: Int64 { get set }
    static var entityName: String { get }
}

extension ActivityDataEntityClass: CustomEntityClass {
    var uid: Int64 {
        get {
            self.id
        }
        set (newVal) {
            self.id = newVal
        }
    }
    
    static var entityName: String {
        return "ActivityData"
    }
    
}

extension RunExerciseDataEntityClass: CustomEntityClass {
    var uid: Int64 {
        get {
            self.id
        }
        set (newVal) {
            self.id = newVal
        }
    }
    static var entityName: String {
        return "RunExerciseData"
    }
}

extension SetsExerciseDataEntityClass: CustomEntityClass {
    var uid: Int64 {
        get {
            self.id
        }
        set (newVal) {
            self.id = newVal
        }
    }
    static var entityName: String {
        return "SetsExerciseData"
    }
}

extension SetsExerciseProgramEntityClass: CustomEntityClass {
    var uid: Int64 {
        get {
            self.id
        }
        set (newVal) {
            self.id = newVal
        }
    }
    static var entityName: String {
        return "SetsExerciseProgramData"
    }
    
    func fill(_ obj: SetsExerciseProgramSettings) {
        self.level = Int32(obj.level)
    }
}


extension SetsExerciseProgramSettings {
    convenience init (_ entity: SetsExerciseProgramEntityClass) {
        self.init()
        self.level = Int(entity.level)
    }
}

extension SetsExerciseLadderEntityClass: CustomEntityClass {
    var uid: Int64 {
        get {
            self.id
        }
        set (newVal) {
            self.id = newVal
        }
    }
    static var entityName: String {
        return "SetsExerciseLadderData"
    }
    
    func fill(_ obj: SetsExerciseLadderSettings) {
        self.from = Int32(obj.from)
        self.to = Int32(obj.to)
        self.steps = Int32(obj.steps)
        self.timeout = obj.timeout
    }
}

extension SetsExerciseLadderSettings {
    convenience init (_ entity: SetsExerciseLadderEntityClass) {
        self.init()
        self.from = UInt(entity.from)
        self.to = UInt(entity.to)
        self.timeout = entity.timeout
    }
}


extension SetsExerciseCustomEntityClass: CustomEntityClass {
    var uid: Int64 {
        get {
            self.id
        }
        set (newVal) {
            self.id = newVal
        }
    }
    static var entityName: String {
        return "SetsExerciseCustomData"
    }
    
    func fill(_ obj: SetsExerciseCustomSettings) {
        self.reps = Int32(obj.reps)
        self.sets = Int32(obj.sets)
        self.timeout = obj.timeout
    }
}

extension SetsExerciseCustomSettings {
    convenience init (_ entity: SetsExerciseCustomEntityClass) {
        self.init()
        self.reps = Int(entity.reps)
        self.sets = Int(entity.sets)
        self.timeout = entity.timeout
    }
}
