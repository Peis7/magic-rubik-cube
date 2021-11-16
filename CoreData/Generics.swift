//
//  Generics.swift
//  MagicRubikCube
//
//  Created by Pedro Luis Cabrera Acosta on 7/14/18.
//  Copyright © 2018 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation
import CoreData
protocol Addable {
    static func +(lhs: Self, rhs: Self) -> Self
}
func addDictionaries<T: Hashable, D: Addable>(firstDict:[T:D],secondDict:[T:D])->[T:D]{
    var result:[T:D] = firstDict
    for n in firstDict.enumerated(){
        if let value = secondDict[n.element.key]{
            result[n.element.key] = result[n.element.key]! + value
        }
    }
    return result
}
func returnArrayWithValueRandomlyReordered<T>(targetArray:Array<T>)->Array<T>{
    var result:Array<T> = Array<T>.init()
    var indexesAvailable:Array<Int> = Array<Int>.init()
    for i in 0..<targetArray.count{
        indexesAvailable.append(i)
    }
    while indexesAvailable.count > 0{
        let index = Int(arc4random_uniform(UInt32(indexesAvailable.count-1)))
        result.append(targetArray[indexesAvailable[ index ]])
        let _ = indexesAvailable.remove(at: index)
    }
    return result
}

extension Session{
    func updateSessionRegisterAt<T>(index:Int,updateData:(key:String,value:T)){
        let fetchRequest: NSFetchRequest<LevelEntity> = LevelEntity.fetchRequest()
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            if (result.count > index){
                result[index].setValue(updateData.value, forKey: updateData.key)
                PersistanctHelper.saveContext()
            }
        }
    }
    func updateSessionRegisterWith<T>(searchTerms:(key:String,value:String),updateData:(key:String,value:T)){
        let fetchRequest: NSFetchRequest<LevelEntity> = LevelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(searchTerms.key)==%@",searchTerms.value as CVarArg)
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            if (result.count>0){
                result[0].setValue(updateData.value, forKey: updateData.key)
                PersistanctHelper.saveContext()
            }
        }
    }
}


extension Config{
    func updateConfigRegisterAt<T>(index:Int,updateData:(key:String,value:T)){
        let fetchRequest: NSFetchRequest<ConfigEntity> = ConfigEntity.fetchRequest()
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            if (result.count > index){
                result[index].setValue(updateData.value, forKey: updateData.key)
                PersistanctHelper.saveContext()
            }
        }
    }
    func updateSessionRegisterWith<T>(searchTerms:(key:String,value:String),updateData:(key:String,value:T)){
        let fetchRequest: NSFetchRequest<ConfigEntity> = ConfigEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(searchTerms.key)==%@",searchTerms.value as CVarArg)
        if let result = try? PersistanctHelper.context.fetch(fetchRequest){
            if (result.count>0){
                result[0].setValue(updateData.value, forKey: updateData.key)
                PersistanctHelper.saveContext()
            }
        }
    }
}
