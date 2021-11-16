//
//  Config.swift
//  MagicRubikCube
//
//  Created by Pedro Luis Cabrera Acosta on 7/13/18.
//  Copyright © 2018 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation
import CoreData

class Config: NSObject {
    var game:Game = .paintAndSolve
    var difficulty:GameDifficultyLevel = GameDifficultyLevel.legend
    static let shared:Config = Config()
    private override init(){
        super.init()
        self.loadDataFromCoreData()
    }
    private func loadDataFromCoreData(){
        if let actualStoredConfig = self.getActualConfigData(){
            self.game = Game.paint.rawValue == actualStoredConfig.game ? Game.paint : Game.paintAndSolve
            self.difficulty = GameDifficultyLevel.brave.rawValue == actualStoredConfig.difficulty ? GameDifficultyLevel.brave :
                GameDifficultyLevel.alpha_male.rawValue == actualStoredConfig.difficulty ? GameDifficultyLevel.alpha_male : GameDifficultyLevel.legend
        }
        self.saveInitialConfigIfNeede()
    }
    private func saveInitialConfigIfNeede(){
        let fetchRequest: NSFetchRequest<ConfigEntity> = ConfigEntity.fetchRequest()
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            if result.count == 0{
                let configEntity:ConfigEntity = ConfigEntity(context: PersistanctHelper.context)
                configEntity.game = Int16(self.game.rawValue)
                configEntity.difficulty_level = Int16(self.difficulty.rawValue)
                PersistanctHelper.saveContext()
            }
            
        }
    }
    private func getActualConfigData()->(game:Int?,difficulty:Int?)?{
        let fetchRequest: NSFetchRequest<ConfigEntity> = ConfigEntity.fetchRequest()
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            if let config =  result.last{
                return (game:Int(config.game),difficulty:Int(config.difficulty_level))
            }else{
                FIRST_TIME_APP_SHOWS = true
            }
        }
        return nil
    }
}
