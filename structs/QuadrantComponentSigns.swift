//
//  QuadrantComponentSigns.swift
//  MagicRubikCube
//
//  Created by Pedro Luis Cabrera Acosta on 7/19/18.
//  Copyright © 2018 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation

struct QuadrantComponentSign{
    static var componentsSign:QuadrantComponentSign = QuadrantComponentSign()
    var xSign:Int!
    var ySign:Int!
    init(){}
    init(xSign:Int,ySign:Int){
        self.init()
        self.xSign = xSign
        self.ySign = ySign
    }
    var signByQuadrant:[SquareSector:QuadrantComponentSign]
            = [.I:QuadrantComponentSign(xSign:1,ySign:1),
               .II:QuadrantComponentSign(xSign:-1,ySign:1),
                .III:QuadrantComponentSign(xSign:-1,ySign:-1),
                    .IV:QuadrantComponentSign(xSign:1,ySign:-1)]
}
