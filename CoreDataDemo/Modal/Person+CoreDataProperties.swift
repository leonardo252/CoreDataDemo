//
//  Person+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Leonardo Gomes on 16/10/20.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int64
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var newFamily: Family?

}

extension Person : Identifiable {

}
