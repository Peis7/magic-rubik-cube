//
//  Util.swift
//  MagicRubikCube
//
//  Created by Pedro Luis Cabrera Acosta on 7/14/18.
//  Copyright © 2018 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit
import CoreData
import StoreKit

class Util {
    static let shared:Util = Util()
    private  init(){
        self.createInitialRegisterForSingletonIntoCoreDataIfNeeded()
    }
    public func shouldAskForRate(movesCount:Int)->Bool{
        let numberOfTImesRatingHasBeenAsked = self.getAskedRateCount()
        guard movesCount > Int(Float(RATE_ASK_TRESHHOLD)*((Float(numberOfTImesRatingHasBeenAsked)*1.5)+Float(numberOfTImesRatingHasBeenAsked))) else{ return false }
        return true
    }
    public func askUserToRateTheApp(movesCount:Int){
        guard shouldAskForRate(movesCount:movesCount) else{return}
        if #available(iOS 10.3, *) {
            self.increaseNumberOfTimesRateTheAppHasBeenShown()
            SKStoreReviewController.requestReview()
        }
        
    }
    private func getAskedRateCount()->Int{
        var numberOfTImesRatingHasBeenAsked:Int = -1
        let fetchRequest:NSFetchRequest<RatingAppEntity> = RatingAppEntity.fetchRequest()
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            if let config =  result.last{
                numberOfTImesRatingHasBeenAsked = Int(config.rate_ask_count)
            }
        }
        return numberOfTImesRatingHasBeenAsked
    }
    private func increaseNumberOfTimesRateTheAppHasBeenShown(){
        let fetchRequest: NSFetchRequest<RatingAppEntity> = RatingAppEntity.fetchRequest()
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            if result.count > 0{
                let trys = Int(result[result.count-1].rate_ask_count)+1
                result[result.count-1].setValue(trys, forKey: "rate_ask_count")
                PersistanctHelper.saveContext()
            }
        }
    }
    private func createInitialRegisterForSingletonIntoCoreDataIfNeeded(){
        guard self.getAskedRateCount() == -1 else{
            return
        }
        self.createInitialRegisterForSingletonIntoCoreData()
    }
    private func createInitialRegisterForSingletonIntoCoreData(){
        let singleton:RatingAppEntity = RatingAppEntity(context: PersistanctHelper.context)
        singleton.already_rated = false
        singleton.rate_ask_count = 1
        PersistanctHelper.saveContext()
    }
}
