//
//  Activity+CoreDataProperties.swift
//  FitnessTracker
//
//  Created by Илья Хачатрян on 25.12.2023.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var duration: Double
    @NSManaged public var id: Int64
    @NSManaged public var type: Int16
    @NSManaged public var username: String?

}

extension Activity : Identifiable {

}
