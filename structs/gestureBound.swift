//
//  gestureBound.swift
//  MagicRubikCube
//
//  Created by Pedro Luis Cabrera Acosta on 7/18/18.
//  Copyright © 2018 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation

class gestureBound:NSObject{
    let leftBound:Double!
    let rightBound:Double!
    init(leftBound:Double,rightBound:Double){
        self.leftBound = leftBound
        self.rightBound = rightBound
    }
}
