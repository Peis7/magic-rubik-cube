//
//  tutorial.swift
//  stackTimerPlus
//
//  Created by Pedro Luis Cabrera Acosta on 29/10/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit

class Tutorial: NSObject {
    var name:String!
    var method:Method? = nil
    init(name:String){
        self.name = name
    }
    func setMethod(method:Method){
        self.method = method
    }
    
}
