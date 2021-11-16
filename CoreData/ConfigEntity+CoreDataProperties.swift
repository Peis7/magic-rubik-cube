//
//  ConfigEntity+CoreDataProperties.swift
//  RubikCubePaint
//
//  Created by Pedro Luis Cabrera Acosta on 2/17/19.
//  Copyright © 2019 Pedro Luis Cabrera Acosta. All rights reserved.
//
//

import Foundation
import CoreData


extension ConfigEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConfigEntity> {
        return NSFetchRequest<ConfigEntity>(entityName: "ConfigEntity")
    }

    @NSManaged public var difficulty_level: Int16
    @NSManaged public var game: Int16

}
