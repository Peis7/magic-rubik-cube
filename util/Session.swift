//
//  File.swift
//  stackTimerPlus
//
//  Created by Pedro Luis Cabrera Acosta on 7/7/18.
//  Copyright © 2018 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation
import CoreData

class Session: NSObject {
    static let shared:Session  = Session()
    var level:Level!
    private override init(){
        super.init()
        self.level = Level(moves: "", time: 0, date:Date(),score:0,state:levelState.waiting,failedTrys:0,missingPeaces: 1,missingPeacesIdentifiers:"",foundPeacesIdentifiers:"",dificulty_level:"",level_number:1,sent_to_server:false)
        self.loadSessionDataFromCoreData()
    }
    public func initLevel(){
        self.level = Level(moves: "", time: 0, date:Date(),score:0,state:levelState.waiting,failedTrys:0,missingPeaces: 1,missingPeacesIdentifiers:"",foundPeacesIdentifiers:"",dificulty_level:"",level_number:1,sent_to_server:false)
    }
    public func loadSessionDataFromCoreData(){
        if let actualStoredLevel = self.getActualSessionConfigData(){
            self.level = Level(moves:actualStoredLevel.moves,time:actualStoredLevel.time,date : actualStoredLevel.date,identifier:actualStoredLevel.identifier,score:actualStoredLevel.score,state:levelState(rawValue: actualStoredLevel.state.rawValue)!,failedTrys:actualStoredLevel.failedTrys,missingPeaces:actualStoredLevel.missingPeaces,missingPeacesIdentifiers:actualStoredLevel.missingPeacesIdentifiers,foundPeacesIdentifiers:actualStoredLevel.foundPeacesIdentifiers,dificulty_level:actualStoredLevel.dificulty_level,level_number:Int(actualStoredLevel.level_number),sent_to_server:actualStoredLevel.sent_to_server)
        }
        saveInitialSessionIfNeede()
    }
    private func saveInitialSessionIfNeede(){
        let fetchRequest: NSFetchRequest<LevelEntity> = LevelEntity.fetchRequest()
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            if result.count == 0{
                let levelEntity:LevelEntity = LevelEntity(context: PersistanctHelper.context)
                let identifier:String = String.randomID()
                levelEntity.moves = ""
                levelEntity.time = 0
                levelEntity.failed_trys = 0
                levelEntity.score = 0
                levelEntity.state = Int16(levelState.inProggress.rawValue)
                levelEntity.date = NSDate()
                levelEntity.identifier = identifier
                self.level.identifier = identifier
                levelEntity.missing_peaces = 1
                levelEntity.level_number = 1
                levelEntity.misssing_peaces_identifiers = ""
                levelEntity.already_found_peaces = ""
                levelEntity.dificulty_level = Config.shared.difficulty.toString()
                PersistanctHelper.saveContext()
            }
        }
    }
    public func getActualSessionConfigData()->Level?{
        let fetchRequest: NSFetchRequest<LevelEntity> = LevelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dificulty_level == %@",Config.shared.difficulty.toString() as CVarArg)
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            if let level =  result.last,let moves = level.moves,let identifier = level.identifier{
                return Level(moves: moves, time:  level.time, date :Date(),identifier: identifier,score:Int(level.score),state:levelState(rawValue: Int(level.state))!,failedTrys:Int(level.failed_trys),missingPeaces:Int(level.missing_peaces),missingPeacesIdentifiers:level.misssing_peaces_identifiers!,foundPeacesIdentifiers:level.already_found_peaces!,dificulty_level:level.dificulty_level!,level_number:Int(level.level_number),sent_to_server:level.sent_to_server)
            }
        }
        return nil
    }
    
}
