//
//  step.swift
//  stackTimerPlus
//
//  Created by Pedro Luis Cabrera Acosta on 29/10/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit

struct Step {
    var identifier:String!
    var methodIdentifier:String!
    var targetImage:String!
    var name:String!
    var description:String!
    var progress:Float! = 0
    var trys:Int! = 0
    init(identifier:String,methodIdentifier:String,name:String,description:String,targetImage:String){
        self.identifier = identifier
        self.name = name
        self.description = description
        self.methodIdentifier = methodIdentifier
        self.targetImage = targetImage
    }
}
