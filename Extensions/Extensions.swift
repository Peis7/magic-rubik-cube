//
//  Extensions.swift
//  RubikCubePaint
//
//  Created by Pedro Luis Cabrera Acosta on 8/4/18.
//  Copyright © 2018 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Array where Element == Int {
    func generateRandonNumbers(count:Int)->Array<Int>{
        var result:Array<Int> = Array<Int>.init()
        while count > result.count{
            result.append(Int(arc4random_uniform(UInt32(self.count))))
        }
        return result
    }
}
extension Array where Element == String {
    func convertToStringSepparateByComma()->String{
        var res:String = ""
        for element in self{
            res="\(res),\(element)"
        }
        return res
    }
}

extension String{
    func convertToJsonObject()->[String:String]?{
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode([String:String].self, from: data)
                return  json
            } catch _ as NSError {
                return nil
            }
        }
        return nil
    }
    func convertStringSeparateByCommasToArray()->Array<Int>{
        var result:Array<Int> = Array<Int>.init()
        let moves = self.split(separator: ",")
        for move in moves{
            if (Int(move) != nil){
                result.append(Int(move)!)
            }
        }
        return result
    }
    static func randomID(length: Int = 12) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    mutating func formaAsAStartTime(){
        self = "00 : 00 . 000"
    }
} 
extension UIView{
    func roundBorder(by with:CGFloat){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = with
    }
    func setBorder(by width:CGFloat){
        self.layer.borderWidth = width
    }
    func setBorderColor(to color:UIColor){
        self.layer.borderColor = color.cgColor
    }
    func configWith(cornerRadius:CGFloat,borderWidth:CGFloat,borderColor:UIColor){
        self.roundBorder(by: cornerRadius)
        self.setBorder(by: borderWidth)
        self.setBorderColor(to:borderColor)
    }
}

extension Level{
    func saveIntoCoreData(){
        let levelEntity:LevelEntity = LevelEntity(context: PersistanctHelper.context)
        levelEntity.moves = self.moves
        levelEntity.date = Date() as NSDate
        levelEntity.identifier = String.randomID()
        levelEntity.score = Int16(self.score)
        levelEntity.state = Int16(self.state.rawValue)
        levelEntity.time = self.time
        levelEntity.failed_trys = Int16(self.failedTrys)
        levelEntity.missing_peaces = Int16(self.missingPeaces)
        levelEntity.already_found_peaces = self.foundPeacesIdentifiers
        levelEntity.misssing_peaces_identifiers = self.missingPeacesIdentifiers
        levelEntity.level_number = Int16(self.level_number)
        levelEntity.dificulty_level = self.dificulty_level
        PersistanctHelper.saveContext()
    }
    
    func updateData(){
        Session.shared.updateSessionRegisterWith(searchTerms: (key:"identifier",value:Session.shared.level.identifier), updateData: (key:"already_found_peaces",value:Session.shared.level.foundPeacesIdentifiers))
        Session.shared.updateSessionRegisterWith(searchTerms: (key:"identifier",value:Session.shared.level.identifier), updateData: (key:"missing_peaces",value:Session.shared.level.missingPeaces))
        Session.shared.updateSessionRegisterWith(searchTerms: (key:"identifier",value:Session.shared.level.identifier), updateData: (key:"score",value:Session.shared.level.score))
        Session.shared.updateSessionRegisterWith(searchTerms: (key:"identifier",value:Session.shared.level.identifier), updateData: (key:"failed_trys",value:Session.shared.level.failedTrys))
    }
    static func sendMissingSolvedLevelsDataToTheServer(){
        let missingLevels = self.getLevelsWaitinToBeSendToServer()
        for level in missingLevels{
            let _ = SolvedData.shared.connector.updateLevelBy(levelname: level.dificulty_level!, missingpeaces: Int(level.level_number))
        }
    }
    static func getLevelsWaitinToBeSendToServer()->[LevelEntity]{
        let fetchRequest: NSFetchRequest<LevelEntity> = LevelEntity.fetchRequest()
        var levels:Array<LevelEntity> = Array<LevelEntity>.init()
        if let result = try? PersistanctHelper.context.fetch(fetchRequest) {
            for level in result{
                if !level.sent_to_server && level.state == levelState.complete.rawValue {
                    levels.append(level)
                }
            }
        }
        return levels
    }
    static func deleteLevelsFor(dificulty_level :String){
        let fetchRequest: NSFetchRequest<LevelEntity> = LevelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dificulty_level == %@", dificulty_level as CVarArg)
        if let result = try? PersistanctHelper.context.fetch(fetchRequest) {
            if (result.count>0){
                for level in result{
                    if level.level_number != 1{
                        PersistanctHelper.context.delete(level)
                    }else{
                        let moves = Scrabler(verticalMoves: ["L","LPrime","R","RPrime","U","UPrime","middleFront"], moves4Scrable: 20, horizontalMoves:["F","B","FPrime","BPrime","D","DPrime","middleSide"]).generateScrable()
                        Session.shared.updateSessionRegisterWith(searchTerms: (key:"identifier",value:level.identifier!), updateData: (key:"moves",value: moves.convertToStringSepparateByComma()))
                    }
                }
            }
        }
    }
    static func lastLevelUserDidNotFinish(dificulty_level :String)->Level?{
        let fetchRequest: NSFetchRequest<LevelEntity> = LevelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dificulty_level == %@", dificulty_level as CVarArg)
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            if (result.count>0){
                for level in result{
                    let missingPeaces = level.misssing_peaces_identifiers?.convertToJsonObject()
                    if (level.state != levelState.complete.rawValue && ((missingPeaces != nil) && missingPeaces!.count > 0)){
                        return Level(moves: level.moves!, time: level.time, date: level.date! as Date, identifier: level.identifier!, score: Int(level.score), state: levelState(rawValue: Int(level.state))!, failedTrys: Int(level.failed_trys), missingPeaces: Int(level.missing_peaces), missingPeacesIdentifiers: level.misssing_peaces_identifiers!, foundPeacesIdentifiers: level.already_found_peaces!, dificulty_level: level.dificulty_level!,level_number:Int(level.level_number),sent_to_server:level.sent_to_server)
                    }
                }
            }
        }
        return nil
    }
    static func getMovesHistoricalCOunt()->Int{
        let fetchRequest: NSFetchRequest<LevelEntity> = LevelEntity.fetchRequest()
        var allTimesMoves = 0
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            let _ = result.map({level in
                allTimesMoves+=level.moves != nil ? level.moves!.convertStringSeparateByCommasToArray().count : 0
            })
        }
        return allTimesMoves
    }
    static func getLevelsCount()->Int{
        let fetchRequest: NSFetchRequest<LevelEntity> = LevelEntity.fetchRequest()
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            return result.count
        }
        return 0
    }
    static func getLevelsCountFor(dificulty_level :String)->Int{
        let fetchRequest: NSFetchRequest<LevelEntity> = LevelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dificulty_level == %@",dificulty_level as CVarArg)
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            return result.count
        }
        return 0
    }
    static func getFinishedLevelFor(dificulty_level :String,missingPeaces:Int)->Level?{
        let fetchRequest: NSFetchRequest<LevelEntity> = LevelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dificulty_level == %@",dificulty_level as CVarArg)
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            for level in result{
                let foundPeaces = level.already_found_peaces?.convertToJsonObject()?.count != nil ? level.already_found_peaces!.convertToJsonObject()!.count : 0
                let missingPeacesForLevel = level.misssing_peaces_identifiers?.convertToJsonObject()?.count != nil ? level.misssing_peaces_identifiers!.convertToJsonObject()!.count : 0
                let levelMissingPeaces = foundPeaces + missingPeacesForLevel
                if level.state == levelState.complete.rawValue && levelMissingPeaces == missingPeaces{
                    return Level(moves: level.moves!, time: level.time, date: level.date! as Date, identifier: level.identifier!, score: Int(level.score), state: levelState(rawValue: Int(level.state))!, failedTrys: Int(level.failed_trys), missingPeaces: Int(level.missing_peaces), missingPeacesIdentifiers: level.misssing_peaces_identifiers!, foundPeacesIdentifiers: level.already_found_peaces!, dificulty_level: level.dificulty_level!,level_number:Int(level.level_number),sent_to_server:level.sent_to_server)
                }
            }
        }
        return nil
    }
    static func getFirstUnsendFinishedLevelFor(dificulty_level :String,missingPeaces:Int)->Level?{
        let fetchRequest: NSFetchRequest<LevelEntity> = LevelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dificulty_level == %@",dificulty_level as CVarArg)
        if let result = try? PersistanctHelper.context.fetch(fetchRequest),result.count > 0 {
            for level in result{
                if level.level_number == missingPeaces && level.state == levelState.complete.rawValue && !level.sent_to_server{
                    return Level(moves: level.moves!, time: level.time, date: level.date! as Date, identifier: level.identifier!, score: Int(level.score), state: levelState(rawValue: Int(level.state))!, failedTrys: Int(level.failed_trys), missingPeaces: Int(level.missing_peaces), missingPeacesIdentifiers: level.misssing_peaces_identifiers!, foundPeacesIdentifiers: level.already_found_peaces!, dificulty_level: level.dificulty_level!,level_number:Int(level.level_number),sent_to_server:level.sent_to_server)
                }
            }
        }
        return nil
    }
    static func getLevelsAt(index:Int)->LevelEntity?{
        let fetchRequest: NSFetchRequest<LevelEntity> = LevelEntity.fetchRequest()
        if let result = try? PersistanctHelper.context.fetch(fetchRequest),result.count>=index{
            return result[index]
        }
        return nil
    }
    static func getLastLevelSolvedFor(dificulty_level :String)->Int{
        let lastLevelSolved:Int = 1
        let fetchRequest: NSFetchRequest<LevelEntity> = LevelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dificulty_level == %@",dificulty_level as CVarArg)
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            if (result.count>0){
                var higherLevelSolved = lastLevelSolved
                for level in result{
                    let _ = level.misssing_peaces_identifiers?.convertToJsonObject()
                    //if level.missing_peaces > higherLevelSolved && ((missingPeaces != nil) && missingPeaces!.count == 0){
                    if level.state == levelState.complete.rawValue{
                        higherLevelSolved = Int(level.missing_peaces)+1
                    }
                }
                return higherLevelSolved
            }
        }
        return lastLevelSolved
    }
}

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func dict2json() -> String {
        return json
    }
}
extension Double{
    func convertTimeInSecondsToMinutes()->Int{
        return Int(floor(self/60.0))
    }
    func getSecondsWithTreshHold(treshHold:Double)->Int{
        return Int(self - treshHold*(floor(self/treshHold)))
    }
}


