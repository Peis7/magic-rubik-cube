//
//  method.swift
//  stackTimerPlus
//
//  Created by Pedro Luis Cabrera Acosta on 29/10/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit

struct Method {
    var identifier:String!
    var name:String!
    var description:String!
    var state:methodState!
    var progress:Float!{
        get{
            var stepsProgress:Float = 0
            for sp in self.steps{
                stepsProgress += sp.progress
            }
            return stepsProgress/(100*Float(self.steps.count))
        }
    }
    var steps:Array<Step>!
    init(identifier:String,name:String,state:methodState,description:String){
        self.identifier = identifier
        self.name = name
        self.state = state
        self.steps = Array.init()
        self.description = description
    }
    mutating func setSteps(steps:Array<Step>){
        self.steps  = steps
    }
}
