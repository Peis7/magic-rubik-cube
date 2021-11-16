//
//  Connector.swift
//  RubikCubePaint
//
//  Created by Pedro Luis Cabrera Acosta on 11/6/18.
//  Copyright © 2018 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit

class Connector: NSObject {
    let baseUrl = "https://pedrocabrera.me/apps/rubikpaint"
    override init(){}
    func getSolvedLevelsData(solvedLevelsData: SolvedData){
        let urlString = URL(string: "\(self.baseUrl)/levelssolvedcount/")
        SolvedData.shared.responseRecived = false
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                SolvedData.shared.responseRecived = true
                if error == nil {
                    var localData:[String:[String: Int]] = [:]
                    if let levelsData = data {
                        let json = try? JSONSerialization.jsonObject(with: levelsData, options: [])
                        if let dictionary = json as? [String: [String: Int]] {
                            for (key, value) in dictionary {
                                localData[key] = value
                            }
                            solvedLevelsData.data = localData
                        }
                    }
                }
            }
            task.resume()
        }
    }
    func updateLevelBy(levelname:String,missingpeaces:Int)->Bool?{
        guard missingpeaces > 0 else{
            return false
        }
        var result:Bool? = false
        let urlString = URL(string: "\(self.baseUrl)/increaseLevelpassedcountby/?levelname=\(levelname)&missingpeaces=\(missingpeaces)")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    result =  false
                } else {
                    if let levelsData = data {
                        let json = try? JSONSerialization.jsonObject(with: levelsData, options: [])
                        if let dictionary = json as? [String: AnyObject] {
                            let solvesCount = dictionary["result"] as? Int
                            let level_name = dictionary["levelname"] as? String
                            let missingpeaces = dictionary["missingpeaces"] as? String
                            if (solvesCount != nil && level_name != nil && missingpeaces != nil && Int(missingpeaces!) != nil){
                                if let level = Level.getFirstUnsendFinishedLevelFor(dificulty_level : level_name!,missingPeaces:Int(missingpeaces!)!){
                                    Session.shared.updateSessionRegisterWith(searchTerms: (key:"identifier",value:level.identifier), updateData: (key:"sent_to_server",value: true))
                                }
                            }
                        }
                    }
                }
            }
            task.resume()
        }
        return result
    }
}
