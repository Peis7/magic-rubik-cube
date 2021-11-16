//
//  RatingAppEntity+CoreDataProperties.swift
//  RubikCubePaint
//
//  Created by Pedro Luis Cabrera Acosta on 2/17/19.
//  Copyright © 2019 Pedro Luis Cabrera Acosta. All rights reserved.
//
//

import Foundation
import CoreData


extension RatingAppEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RatingAppEntity> {
        return NSFetchRequest<RatingAppEntity>(entityName: "RatingAppEntity")
    }

    @NSManaged public var already_rated: Bool
    @NSManaged public var rate_ask_count: Int16

}
