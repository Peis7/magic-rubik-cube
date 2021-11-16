//
//  Session.swift
//  MagicRubikCube
//
//  Created by Pedro Luis Cabrera Acosta on 7/14/18.
//  Copyright © 2018 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation

struct Level{
    var moves:String!
    var missingPeacesIdentifiers:String!
    var foundPeacesIdentifiers:String!
    var time:Double!
    var score:Int!
    var failedTrys:Int!
    var date:Date = Date()
    var identifier:String!
    var state:levelState = .waiting
    var missingPeaces:Int!
    var dificulty_level:String!
    var level_number:Int!
    var sent_to_server:Bool = false
    init(moves:String,time:Double,date :Date = Date(),score:Int = 0,state:levelState,failedTrys:Int = 0,missingPeaces:Int = 1,missingPeacesIdentifiers:String,foundPeacesIdentifiers:String,dificulty_level:String,level_number:Int=1,sent_to_server:Bool){
        self.moves = moves
        self.time = time
        self.date = date
        self.score = score
        self.failedTrys = failedTrys
        self.state = state
        self.missingPeaces = missingPeaces
        self.missingPeacesIdentifiers = missingPeacesIdentifiers
        self.foundPeacesIdentifiers = foundPeacesIdentifiers
        self.dificulty_level = dificulty_level
        self.level_number = level_number
        self.sent_to_server = sent_to_server
    }
    init(moves:String,time:Double,date :Date = Date(),identifier:String,score:Int = 0,state:levelState,failedTrys:Int = 0,missingPeaces:Int = 1,missingPeacesIdentifiers:String,foundPeacesIdentifiers:String,dificulty_level:String,level_number:Int,sent_to_server:Bool){
        self.init(moves: moves, time: time, date: date, score: score,state:state, failedTrys: failedTrys,missingPeaces:missingPeaces,missingPeacesIdentifiers:missingPeacesIdentifiers,foundPeacesIdentifiers:foundPeacesIdentifiers,dificulty_level:dificulty_level,level_number:level_number,sent_to_server:sent_to_server)
        self.identifier = identifier
    }
    init(){}
    func getMovesAsArray()->Array<Int>{
        return self.moves.convertStringSeparateByCommasToArray()
    }
    func getmissingPeacesIdentifiersAsArray()->Array<Int>{
        return self.missingPeacesIdentifiers.convertStringSeparateByCommasToArray()
    }
    func getReallMissingPeacesDataAsDict()->[String:String]{
        guard var missingPeaces:[String:String] = Session.shared.level.missingPeacesIdentifiers.convertToJsonObject() else{
            return [:]
        }
        if let alreadyFoundPeaces:[String:String] = Session.shared.level.foundPeacesIdentifiers.convertToJsonObject() {
            for data in alreadyFoundPeaces.enumerated(){
                missingPeaces.removeValue(forKey: "\(data.element.key)")
            }
            Session.shared.level.missingPeacesIdentifiers = missingPeaces.dict2json()
        }
        return missingPeaces
    }
    func getLevelNumber()->Int{
        let foundPeaces = self.foundPeacesIdentifiers?.convertToJsonObject()?.count != nil ? self.foundPeacesIdentifiers!.convertToJsonObject()!.count : 0
        let missingPeacesForLevel = self.missingPeacesIdentifiers?.convertToJsonObject()?.count != nil ? self.missingPeacesIdentifiers!.convertToJsonObject()!.count : 0
        return  foundPeaces + missingPeacesForLevel
    }
   
}
