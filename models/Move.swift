//
//  Move.swift
//  stackTimerPlus
//
//  Created by Pedro Luis Cabrera Acosta on 29/10/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit
//like sexy move, is a set of moves then is represented by other moves
class Move: NSObject {
    var name:String!
    var lowLevelName:String!
    init(name:String,lowLevelName:String){
        self.name = name
        self.lowLevelName = lowLevelName
    }
}
