//
//  ActivityEntityClass+CoreDataProperties.swift
//  FitnessTracker
//
//  Created by Ilia Khachatrian on 03.03.2024.
//
//

import Foundation
import CoreData


extension ActivityEntityClass {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityEntityClass> {
        return NSFetchRequest<ActivityEntityClass>(entityName: "Activity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var duration: Double
    @NSManaged public var id: Int64
    @NSManaged public var type: Int16
    @NSManaged public var username: String?
    @NSManaged public var exerciseDataId: Int64

}

extension ActivityEntityClass : Identifiable {

}
