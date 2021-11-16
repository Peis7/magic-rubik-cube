//
//  state.swift
//  stackTimerPlus
//
//  Created by Pedro Luis Cabrera Acosta on 29/12/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation

class State: NSObject {
    var name:String!
    var cubeScreenShot:[CubeColor:Array<(CubeColor,(Int,Int))>]? = nil
    
    init(name:String,cubeScreenShot:[CubeColor:Array<(CubeColor,(Int,Int))>]?){
        self.name = name
        self.cubeScreenShot = cubeScreenShot
    }
}
