//
//  SolvedData.swift
//  RubikCubePaint
//
//  Created by Pedro Luis Cabrera Acosta on 11/7/18.
//  Copyright © 2018 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit

class SolvedData: NSObject {
    let connector:Connector = Connector()
    static let shared:SolvedData = SolvedData()
    var responseRecived:Bool = false
    private override init(){
        super.init()
    }
    var data:[String:[String:Int]] = [:]
    public func getData(){
            connector.getSolvedLevelsData(solvedLevelsData: self)
    }
}
