//
//  CubeItem.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 23/6/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation

class CubeItem{
    var type:partType!
    var identifier:Int!//must identify an item from any other item of the same cube
    //represents the basic unit of a cube(rectagle like a edge,center or a corner)
    var rotations:[cubeColumnMove:[MoveOrigin:[VectorDirection:VectorDirection]]]!
    var vectors:Array<Vector>!//each item must have at least two, and max 3 vectors, note:consider using a dictionary
    var vectorsOpposite:[VectorDirection:VectorDirection] = [VectorDirection.Front:VectorDirection.Back,VectorDirection.Up:VectorDirection.Down,VectorDirection.Left:VectorDirection.Right]//given the oppossites, any relation for the faces may be calculated
    
    var uniformColor:CubeColor? = nil //special item, whos color wil remain in this specific color, all of them
    init(){
        self.vectors = Array<Vector>()//vector size will be determinated by face type
        self.setVectorsRelation()
    }
    init(cubePart:partType){
        self.type = cubePart
        self.vectors = Array<Vector>()//vector size will be determinated by face type
        self.setVectorsRelation()
    }
    func getDescriptionfor()->String{
        guard let type = self.type else{
            return "Nil Value"
        }
        switch type {
        case .Arist:
            return "Arist"
        case .Center:
            return "Center"
        case .Corner:
            return "Corner"
        }
    }
    func setVectorsWith(data:Array<Vector>){
        self.vectors = data
    }
    func change(vector:Vector,to:Vector){
        for i in 0..<self.vectors.count{
            if self.vectors[i].vectorDirection == vector.vectorDirection{
                self.vectors[i] = to
            }
        }
    }
    func setVectorsRelation(){
        self.rotations = [
            cubeColumnMove.Vertical:[
                .Frontal:[.Front:.Up,.Up:.Back,.Back:.Down,.Down:.Front,.Right:.Right,.Left:.Left],.Side:[.Front:.Front,.Up:.Left,.Back:.Back,.Down:.Right,.Right:.Up,.Left:.Down,]],
            cubeColumnMove.Horizontal:[
                .Frontal:[.Front:.Right,.Up:.Up,.Back:.Left,.Down:.Down,.Right:.Back,.Left:.Front],.Side:[.Front:.Right,.Up:.Up,.Back:.Left,.Down:.Down,.Right:.Back,.Left:.Front]],
            cubeColumnMove.VerticalP:[.Frontal:[:],.Side:[:]],cubeColumnMove.HorizontalP:[.Frontal:[:],.Side:[:]]
        ]
        self.setPrimeMoves(fromColumnMove: .Vertical, toColumnMove: .VerticalP, moveOrigin: .Frontal)
        self.setPrimeMoves(fromColumnMove: .Horizontal, toColumnMove: .HorizontalP , moveOrigin: .Frontal)
        self.setPrimeMoves(fromColumnMove: .Vertical, toColumnMove: .VerticalP, moveOrigin: .Side)
        self.setPrimeMoves(fromColumnMove: .Horizontal, toColumnMove: .HorizontalP , moveOrigin: .Side)
    }
    //giveVertiacl and Horizontal, Prime moves are just the key of the value in the Dictionaries,this one set them all,getPrimeMovements get an secific one
    func setPrimeMoves(fromColumnMove:cubeColumnMove,toColumnMove:cubeColumnMove,moveOrigin:MoveOrigin){
        var primeMoves:[MoveOrigin:[VectorDirection:VectorDirection]] = [moveOrigin:[:]]
        primeMoves[moveOrigin] = [:]
        var vdir = [VectorDirection:VectorDirection]()
        if let vectors = self.rotations[fromColumnMove]?[moveOrigin]{
            for v in vectors.keys{
                vdir[vectors[v]!] = v
            }
            self.rotations[toColumnMove]![moveOrigin] = vdir
        }
    }
    
    func getPrimeMovements(columnMove:cubeColumnMove,moveOrigin:MoveOrigin,vd:VectorDirection)->VectorDirection?{
        var res:VectorDirection? = nil
        if columnMove == .Horizontal || columnMove == .Vertical{
            return self.rotations[columnMove]?[moveOrigin]?[vd]
        }
        if let x = self.rotations[columnMove]?[moveOrigin]{
            for (key,value) in x{
                if value == vd{
                    res = key
                }
            }
        }
        return res
    }
    func proccessRotation(degrees dgrs:degrees,direction:cubeColumnMove,moveOrigin:MoveOrigin)->[VectorDirection:CubeColor]{
        var result:[VectorDirection:CubeColor] = [:]
        for i in 0..<self.vectors.count{
            let r = self.Rotate(direction: direction, moveOrigin: moveOrigin, vectorDirection: self.vectors[i].vectorDirection,degreesRepresentation: dgrs.rawValue)
            self.vectors[i].vectorDirection = r
            result[r!] =  self.vectors[i].useUniformColor != nil ? self.vectors[i].useUniformColor : self.vectors[i].color
        }
        return result
    }
    func setItemAsUniformColor(color:CubeColor){
        self.uniformColor = color
    }
    
    func Rotate(direction:cubeColumnMove,moveOrigin:MoveOrigin,vectorDirection:VectorDirection,degreesRepresentation:Int)->VectorDirection?{
        if var rot = self.rotations[direction]?[moveOrigin]?[vectorDirection]{
            if degreesRepresentation != 1{
                rot = self.Rotate(direction: direction, moveOrigin: moveOrigin, vectorDirection: rot, degreesRepresentation: degreesRepresentation-1)!
            }
            return rot
        }
        return nil
    }
    func getColors()->Array<CubeColor>{
        var colors:Array<CubeColor> = Array.init()
        for c in self.vectors{
            colors.append(c.color)
        }
        return colors
    }
    //update
    func getUniqueItemVectorDirectionByUniqueIdentifier(identifier:Int)->Face?{
        for vector in self.vectors{
            if (vector.uniqueIdentifier == identifier){
                return vector.vectorDirection
            }
        }
        return nil
    }
    func getVectorPointingTo(face: Face)->Int?{
        for vector in self.vectors{
            if (vector.vectorDirection == face){
                return vector.uniqueIdentifier
            }
        }
        return nil
    }
    func setVectorToUnifor(color:CubeColor){
        for vector in self.vectors{
            vector.setUniforColor(color: color)
        }
    }
    func setVectorPointingTo(face:Face,toColor color:CubeColor){
        for i in 0..<self.vectors.count{
            if self.vectors[i].vectorDirection == face{
                self.vectors[i].setUniforColor(color: color)
            }
        }
    }
    
}
