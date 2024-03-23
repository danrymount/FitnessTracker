

import CoreData
import Foundation


protocol CustomEntityClass: NSManagedObject {
    static var entityName: String { get }
}

extension ActivityDataEntityClass: CustomEntityClass {
    static var entityName: String {
        return "ActivityData"
    }
    
}

extension RunExerciseDataEntityClass: CustomEntityClass {
    static var entityName: String {
        return "RunExerciseData"
    }
}

extension SetsExerciseDataEntityClass: CustomEntityClass {
    static var entityName: String {
        return "SetsExerciseData"
    }
}
