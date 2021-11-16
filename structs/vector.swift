//
//  vector.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 23/6/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation


class Vector{
    var uniqueIdentifier:Int? = nil
    var vectorDirection:VectorDirection!
    var color:CubeColor!//the color this vector is related to,:)
    var base:Bool!//use to be de pivot in a rotation,if base = Front and rotate
    var useUniformColor:CubeColor? = nil
    
    init(vectorDirection vd:VectorDirection,color:CubeColor,base:Bool,uniqueIdentifier:Int){
        self.vectorDirection = vd
        self.color = color
        self.base = base
        self.uniqueIdentifier = uniqueIdentifier
    }
    init(vectorDirection vd:VectorDirection,color:CubeColor,base:Bool){
        self.vectorDirection = vd
        self.color = color
        self.base = base
    }
    func setUniforColor(color:CubeColor?){
        self.useUniformColor = color
    }
    init(){}
}


