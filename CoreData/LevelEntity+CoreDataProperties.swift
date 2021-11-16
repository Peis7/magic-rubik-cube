//
//  LevelEntity+CoreDataProperties.swift
//  RubikCubePaint
//
//  Created by Pedro Luis Cabrera Acosta on 3/29/19.
//  Copyright © 2019 Pedro Luis Cabrera Acosta. All rights reserved.
//
//

import Foundation
import CoreData


extension LevelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LevelEntity> {
        return NSFetchRequest<LevelEntity>(entityName: "LevelEntity")
    }

    @NSManaged public var already_found_peaces: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var dificulty_level: String?
    @NSManaged public var failed_trys: Int16
    @NSManaged public var identifier: String?
    @NSManaged public var level_number: Int16
    @NSManaged public var missing_peaces: Int16
    @NSManaged public var misssing_peaces_identifiers: String?
    @NSManaged public var moves: String?
    @NSManaged public var score: Int16
    @NSManaged public var state: Int16
    @NSManaged public var time: Double
    @NSManaged public var sent_to_server: Bool

}
