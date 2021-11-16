//
//  Cube.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 21/3/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation


extension Array where Element == Int{
    func containsAnyItemOf(target:Array<Int>)->Bool{
        for item in target{
            if self.contains(item){
                return true
            }
        }
        return false
    }
}
extension Array where Element == CubeColor{
    func totallyContains(target:Array<CubeColor>)->Bool{
        guard self.count >= target.count else{
            return false
        }
        for item in target{
            if !self.contains(item){
                return false
            }
        }
        return true
    }
}
extension Array where Element == Int{
    
    func matchingItemsOf(target:Array<Int>)->Array<Int>{
        var result:Array<Int> = Array.init()
        for item in target{
            if self.contains(item){
                result.append(item)
            }
        }
        return result
    }
    func merge(target:Array<Int>)->Array<Int>{
        var result:Array<Int> = Array.init()
        for item in self{
            if target.contains(item){
                result.append(item)
            }
        }
        return result
    }
}
class RubikCube{
    var baseWidth:Int!
    var baseHeight:Int!
    var cubeHeight:Int!
    var firstSolvedFaceColor:CubeColor = CubeColor.White//
    var uniqueIdentifiersStartPosition:Int!
    var colors:Array<CubeColor>!
    var cubeItems:Array<CubeItem>!
    var partsCount:[partType:Int]!
    var centerPeacesPerFace:Int!
    var cubeItemsUniqueIdentifier:[Int:Array<Int>]!
    var identifierAsociatedItem:[Int:Int]!
     var identifierAsociatedFace:[Int:Face]!
    var facesOpposites:[Face:Face]!//update
    var itemsRealIndex:[Int:Int]!//update
    var itemsCoordenates:[Int:(Int,Int)]!//where in the grid of a face an item must be
    var moveParalelFaces:[Face:[MoveOrigin:[cubeColumnMove:Array<Face>]]]!//if move from Front face, parallele to move would be roght and left
    var standarMovesFacesEquivalences:[Face:[String:String]]!
    var partsPositions:[partType:Array<Int>]!
    var base:(color:CubeColor,face:Face)!//may use alway (Front,White)
    var faceColRowPos:[Face:Int]!//use to get a face numeric representation
    var facesOppositeColors:[CubeColor:CubeColor]!
    var facesColor:[Face:CubeColor]!//shoul determinate using cammeras and a camera as a front face for reference :), will be use tu dterminate if cube is solve and also for center peaces while determninaten cube state with cameras
    var faces:Array<Face>!
    var facesInitialColors:[Face:Array<CubeColor>]!
    var facesItemsPositions:[Face:[Int:Int]]!//useful to optimize eficciency, here i have a dictionary with cubeItem index as key and position as value/color etc,considere this as lazy cause may take a long to calculate, this may only help for 3x3x3, but for 4x4x4 or nxmxl will be useless for inner columns, next a better approach
    var faceUniqueIdentifiers:[Face:[Int:Int]]!
    var columsItemsPositions:[MoveOrigin:[cubeColumnMove:[Int:Array<Int>]]]!
    var rotationJumps:[Int:[RotationOrientation:[Int:Array<Int>]]]!//first key,column/row,second inner key, jumplenght, inner points ex. [1:[4:[2,3]]],[3:[3:[4,1]]]//not include destiny
    var columnsRowsChangeOrientation:[Face:[Face:[cubeColumnMove:Int]]]!//0 nothing to do, 1 reverse array
    var columnsOrRows:[MoveOrigin:[cubeColumnMove:[Face:Bool]]]!
    var itemsPositiosForRotations:[cubeColumnMove:[MoveOrigin:[Face:[Int:Int]]]]!
    var cubeUnitsZise:Int{//number of items that represent an entire cube
        get{
            guard let bw = self.baseWidth,let bh = self.baseHeight,let ch = self.cubeHeight  else{
                return 0
            }
            return bw*bh*ch
        }
    }
    
    var facesIndexData:[Face:Array<Int>]!//here i store index based in the unidimensional array, if not symmetrical, front and back faces would be  be same item sizes
    
    init(baseWidth bw:Int,baseHeight bh:Int,cubeHeight ch:Int,uniqueIdentifiersStartPosition:Int,items:Array<CubeItem>){
        self.baseWidth = bw
        self.baseHeight = bh
        self.cubeHeight = ch
        self.itemsRealIndex = [:]//update
        self.uniqueIdentifiersStartPosition = uniqueIdentifiersStartPosition
        if self.cubeUnitsZise == items.count{
            self.cubeItems = items
        }
        else{
            self.cubeItems =  Array.init(repeating: CubeItem.init(), count: self.cubeUnitsZise)
        }
        self.facesOpposites = [Face.Front:Face.Back,Face.Left:Face.Right,Face.Up:Face.Down,Face.Down:Face.Down,Face.Back:Face.Front,Face.Right:Face.Left]
        self.colors = [.Blue,.Green,.Orange,.Red,.White,.Yellow]//must be updated if custom colors are used
        self.faces = [.Front,.Back,.Down,.Left,.Right,.Up]//order matters for unique identifiers,be careful if reordering
        self.faceColRowPos = [.Front:0,.Back:self.baseHeight-1,.Down:0,.Up:self.cubeHeight-1,.Right:0,.Left:self.baseWidth-1]//.Front face is 0 becouse from(watching from right), front & back columns from a side, right & left are columns seen fron the front and up and down re rows if you see fron the front or a side
        self.facesColor = [.Front:.Blue,.Right:.Red,.Up:.Yellow,.Left:.Orange,.Back:.Green,.Down:.White,]//not updated while movinng by 01-10-2017, because i still not need for that
        self.facesOppositeColors = [.White:.Yellow,.Green:.Blue,.Red:.Orange,.Orange:.Red,.Yellow:.White,.Blue:.Green]
        self.initializeitemsRealIndex()//update
        self.facesInitialColors = [:]
        self.identifierAsociatedFace = [:]
        self.partsPositions = [:]
        self.facesIndexData = [:]
        self.facesItemsPositions = [:]
        self.columsItemsPositions = [:]
        self.rotationJumps = [:]
        self.columnsRowsChangeOrientation = [:]
        self.standarMovesFacesEquivalences = [:]
        self.moveParalelFaces = [:]
        self.identifierAsociatedItem = [:]
        self.cubeItemsUniqueIdentifier = [:]
        self.itemsCoordenates  = [:]
        self.partsCount = [:]
        self.setFacesIndexData()
        self.base = (CubeColor.White,Face.Front)
        self.setFacesInitialColors()
        self.setfacesItemsPositions()
        self.setPartsCount()
        self.setRotationJumps(envolvedFaces: 4)
        self.setColumnsRowsChangeOrientation()
        self.setItemsPositiosForRotations()
        self.setMoveParalelFaces()
        self.setCenterPeacesPerFace()
    }
    func initializeitemsRealIndex(){
        guard self.itemsRealIndex.count == 0 else{
            return
        }
        for i in 0..<self.cubeItems.count{
            self.itemsRealIndex[i] = i
        }
    }
    func setPartsCount(){
        let pCounts = self.getPartsCount()
        self.partsCount[.Arist] = pCounts[.Arist]
        self.partsCount[.Center] = pCounts[.Center]
        self.partsCount[.Corner] = pCounts[.Corner]
    }
    func setCenterPeacesPerFace(){
        guard let centersCount = self.partsCount[.Center] else{
            return
        }
        self.centerPeacesPerFace = Int(centersCount/self.faces.count)
    }
    func assignUniqueIdentifierToCubeItem(){//
        var id = 1
        for item in self.cubeItems{
            item.identifier = id
            id+=1
        }
    }
    func getItemAsociatedIdentifiers(index:Int)->Array<Int>{//return identifiers asociated to an specific item, by usin item index
        if let ids = self.cubeItemsUniqueIdentifier[index]{
            return ids
        }
        return []
    }
    func getUniqueIdentifiersOfItemGiven(uniqueIdentifier:Int)->Array<Int>{//return identifiers asociated to an specific item, by usin item index
        if let item = self.identifierAsociatedItem[uniqueIdentifier]{
            if let ids = self.cubeItemsUniqueIdentifier[item]{
                return ids
            }
        }
        return []
    }
    func setMoveParalelFaces(){
        self.moveParalelFaces[.Front] = [.Frontal:[.VerticalP:[.Right,.Left],.Vertical:[.Right,.Left],.Horizontal:[.Up,.Down],.HorizontalP:[.Up,.Down]]]
        self.moveParalelFaces[.Right] = [.Side:[.VerticalP:[.Front,.Back],.Vertical:[.Front,.Back],.Horizontal:[.Up,.Down],.HorizontalP:[.Up,.Down]]]
        self.moveParalelFaces[.Up] = [.Frontal:[.VerticalP:[.Right,.Left],.Vertical:[.Right,.Left],.Horizontal:[.Right,.Left],.HorizontalP:[.Right,.Left]]]
    }
    
    func setColumnsRowsChangeOrientation(){
        self.columnsRowsChangeOrientation[.Front] = [.Back:[.Vertical:0,.VerticalP:0]]
        self.columnsRowsChangeOrientation[.Right] = [.Up:[.Vertical:0,.VerticalP:0],.Left:[.Vertical:0,.VerticalP:0],.Down:[.Vertical:0,.VerticalP:0]]
        self.columnsRowsChangeOrientation[.Back] = [.Up:[.Vertical:0,.VerticalP:0],.Front:[.Vertical:0,.VerticalP:0],.Down:[.Vertical:0,.VerticalP:0]]
        self.columnsRowsChangeOrientation[.Up] = [.Right:[.Horizontal:0,.HorizontalP:0],.Down:[.Horizontal:0,.HorizontalP:0],.Back:[.Vertical:0,.VerticalP:0]]
        self.columnsRowsChangeOrientation[.Down] = [.Back:[.Vertical:0,.VerticalP:0],.Right:[.Horizontal:0,.HorizontalP:0],.Left:[.Horizontal:0,.HorizontalP:0]]
        self.columnsRowsChangeOrientation[.Left] = [.Right:[.Vertical:0,.VerticalP:0],.Down:[.Vertical:0,.VerticalP:0]]
    }
    func setColumnsOrRows(){//if not nil row, else not change and are horizontal o vertical columns that are treated  like this
        self.columnsOrRows = [:]
        self.columnsOrRows[.Side] = [.Vertical:[.Up:true],.VerticalP:[.Up:true],.Vertical:[.Down:true],.VerticalP:[.Down:true]]
    }
    
    //to reuse move functions(only perspective change if using other face),using up as base face for already define moves(functions)
    //works for 3x3x3 and 2x2x2 now, maybe it can be dynamic, we asume that we can oly ineract with 3 faces  ot the cube in an specific moment
    func setStandarMovesFacesEquivalences(){
        self.standarMovesFacesEquivalences[.Up] = ["R":"R","L":"L","U":"U","UPrime":"UPrime","RPrime":"RPrime","LPrime":"LPrime"]
        self.standarMovesFacesEquivalences[.Right] = ["L":"FPrime","LPrime":"F","R":"B","RPrime":"BPrime","D":"D","DPrime":"DPrime","U":"U","UPrime":"UPrime"]
    }
    func getUniqueIdentifierFace(face:Face)->[Int:Int]{
        guard let identifiers = self.faceUniqueIdentifiers[face] else{
            return [:]
        }
        return identifiers
    }
    func getUniqueidentifiersRange()->(start:Int,end:Int){
        return (self.uniqueIdentifiersStartPosition,self.uniqueIdentifiersStartPosition+self.baseWidth*self.baseHeight*self.faces.count)
    }
    
    //aproach no used now, not efficient
    func rotate(arrayData:Array<Int>,face:Face,degrees:ArrayRotationDegrees,columnMoveOrientation:cubeColumnMove)->[Int:Int]{//degrees may be just an iteration number = degrees.rawvalue, but now dont use it
       let rotationOrientation:RotationOrientation  = (columnMoveOrientation == .Horizontal || columnMoveOrientation == .Vertical) ? .ClockWise : .OppClockWise
        let rotatedItemsData = self.executeRotation(arrayData:arrayData,face:face,rotationOrientation:rotationOrientation,rotationsCount:degrees.rawValue)
        var temporalItems = [Int:CubeItem]()
        self.rotateItemsIn(collection: arrayData,columnMoveOrientation:columnMoveOrientation)
        for data in rotatedItemsData{
            temporalItems[arrayData[data.key]] = self.cubeItems[arrayData[data.key]]
            if (temporalItems[data.value] !=  nil){
                self.cubeItems[arrayData[data.key]] = temporalItems[data.value]!
            }else{
                self.cubeItems[arrayData[data.key]] = self.cubeItems[data.value]
            }
        }
        return rotatedItemsData
    }
    
    func rotateItemsIn(collection:Array<Int>,columnMoveOrientation:cubeColumnMove){
        for j in collection{
            _ = self.cubeItems[j].proccessRotation(degrees: .D90, direction: columnMoveOrientation, moveOrigin: .Frontal)
        }
    }
    func executeRotation(arrayData:Array<Int>,face:Face,rotationOrientation:RotationOrientation,rotationsCount:Int)->[Int:Int]{//degrees may be just an iteration number = degrees.rawvalue, but now dont use it
        var position = 0
        var result:[Int:Int] = [:]
        let columnsCount = face == .Left || face == .Right ? self.baseHeight! : self.baseWidth!
        var faceIndexes = [Int]()
        var y = self.cubeHeight-1
        for column in 0..<columnsCount{
            var z = 0
            for i in (0..<self.cubeHeight).reversed(){
                if rotationOrientation == .ClockWise{
                    result[position] = arrayData[y+z*columnsCount]//position: of the index at the array result
                    faceIndexes.append(arrayData[y+z*columnsCount])
                }else{
                    result[position] = arrayData[column+i*columnsCount]
                    faceIndexes.append(arrayData[column+i*columnsCount])
                }
                position+=1
                z+=1
            }
            y-=1
        }
        
        if rotationsCount != 1{
            result =  self.executeRotation(arrayData: faceIndexes, face: face, rotationOrientation: rotationOrientation,rotationsCount:rotationsCount-1)
        }
        return result
    }
    func reverseRowsFor(arrayData:Array<Int>,rowsCount:Int,rowLength:Int)->[Int:Int]{
        var position = 0
        var result:[Int:Int] = [:]
        for row in 0..<self.cubeHeight{//cubeHeight is burn here, must be dynamic based for nxlxm
            for i in (0..<rowLength).reversed(){
                result[position] = arrayData[i+row*rowLength]
                position+=1
            }
        }
        return result
    }
    func assoicatePositionToItemIndexRepresentation(face:Face)->[Int:Int]{
        let faceRepresentation = self.getFaceNumericRepresentation(face: face)
        var result:[Int:Int] = [:]
        for (index,value) in faceRepresentation.enumerated(){
            result[index] = value
        }
        return result
    }
    func moveEntireCube(moveOrigin:MoveOrigin,degrees:degrees,cubeColumnMove:cubeColumnMove){//for a complete cube move, change new fron face
        do {
            for i in 0..<self.baseWidth{
                let _ = try self.ROTATE(faceOfMoveOrigin: .Front, columnMove: cubeColumnMove, moveOrigin: moveOrigin, index: i, degrees: degrees)
            }
        }catch let error{
            print("Error rotating \(error)")
        }
    }
    func setItemsPositiosForRotations(){
        func setDataTo(cubeCM:cubeColumnMove,moveOrigin:MoveOrigin,face:Face,arrayRotationDegrees:ArrayRotationDegrees){
            var data:Array<Int> = Array.init()
            var rotatedData:[Int:Int] = [:]
            if self.itemsPositiosForRotations[cubeCM] != nil{
                if self.itemsPositiosForRotations[cubeCM]![moveOrigin] != nil{
                    self.itemsPositiosForRotations[cubeCM]![moveOrigin]![face] = [:]
                }else{
                    self.itemsPositiosForRotations[cubeCM]![moveOrigin] = [:]
                }
            }else{
                self.itemsPositiosForRotations[cubeCM] = [:]
                self.itemsPositiosForRotations[cubeCM]![moveOrigin] = [:]
            }
            let itemsPos = self.facesItemsPositions[face]!
            for i in 0..<itemsPos.keys.count{
                for key in (itemsPos.keys){
                    if (key == i){
                        data.append(itemsPos[key]!)
                        break
                    }
                }
            }
            rotatedData = self.executeRotation(arrayData: data, face: face, rotationOrientation:.OppClockWise, rotationsCount: arrayRotationDegrees.rawValue)
            data.removeAll()
            self.itemsPositiosForRotations[cubeCM]?[moveOrigin]?[face] = rotatedData
        }
        self.itemsPositiosForRotations = [:]
        setDataTo(cubeCM:cubeColumnMove.Vertical,moveOrigin:MoveOrigin.Frontal,face:Face.Back,arrayRotationDegrees:ArrayRotationDegrees.D180)
        setDataTo(cubeCM:cubeColumnMove.Vertical,moveOrigin:MoveOrigin.Side,face:Face.Up,arrayRotationDegrees:ArrayRotationDegrees.D90)
        setDataTo(cubeCM:cubeColumnMove.Vertical,moveOrigin:MoveOrigin.Side,face:Face.Right,arrayRotationDegrees:ArrayRotationDegrees.D180)
        setDataTo(cubeCM:cubeColumnMove.Vertical,moveOrigin:MoveOrigin.Side,face:Face.Down,arrayRotationDegrees:ArrayRotationDegrees.D270)
    }
    func setRotationJumps(envolvedFaces:Int){
        for i in 1...envolvedFaces{
            self.rotationJumps[i] = [:]
            var colRowJumps = [Int:Array<Int>]()
            for j in 1...(envolvedFaces-1){
                var point:Int = i
                var innerPoints = Array<Int>.init()
                for _ in i..<i+j{
                    point = ((point == envolvedFaces) ? 1:point+1)
                    innerPoints.append(point)
                    
                }
                colRowJumps[j] = innerPoints
            }
            self.rotationJumps[i]?[RotationOrientation.ClockWise]  = colRowJumps
        }
        for j in 1...envolvedFaces{
            self.rotationJumps[j]?[RotationOrientation.OppClockWise] = [:]
            for k in 1...envolvedFaces-1{
                let staring_for_inverse_move = (k >= j) ? envolvedFaces - (k-j) - 1 : ((j-k-1)==0 ? envolvedFaces:(j-k-1))
                let reversed = self.rotationJumps[staring_for_inverse_move]?[RotationOrientation.ClockWise]?[k]?.reversed().map{$0}
                self.rotationJumps[j]?[RotationOrientation.OppClockWise]?[k] = reversed
            }
            
        }
    }
    
    func calculateMovesToMove(fromIndex:Int,toIndex:Int)->Array<Int>{//missing,pendent,unfinished
        let moves:Array<Int> = Array.init()
        /*
         1. Get column and row for both(fromIndex and toIndex)
         2. At the end, toIndex Column = fromIndex Column && toIndex Row = fromIndex Row
         */
        
        return moves
    }
    func createFaceUniqueIdentifiers(lastValueUsed:Int,face:Face)->Int{
        guard let items =  self.facesItemsPositions[face] else{
            return lastValueUsed
        }
        var value = lastValueUsed
        var uniqueValues:[Int:Int] = [:]
        var i = 0
        var identifiers:Array<Int> = []
        for (key,val) in items{
            value+=1
            identifiers = []
            if let currentIdentifiers = self.cubeItemsUniqueIdentifier[val]{
                identifiers = currentIdentifiers
            }
            identifiers.append(value)
            self.identifierAsociatedItem[value] = val
            self.cubeItemsUniqueIdentifier[val] = identifiers
            uniqueValues[items[key]!] = value
            i+=1
        }
        self.faceUniqueIdentifiers[face] = uniqueValues
        return value
    }
    func setfacesItemsPositions(){//may use this for setColumItemPositions externl leyers
        self.faceUniqueIdentifiers = [:]
        var lastValue4UniqueValues = self.uniqueIdentifiersStartPosition!
        for face in self.faces{
            if face == .Front || face == .Left{//reverse rows
                let rowLength = face == .Left || face == .Right ? self.baseHeight! : self.baseWidth!
                self.facesItemsPositions[face] = self.reverseRowsFor(arrayData: self.getFaceNumericRepresentation(face: face), rowsCount:rowLength,rowLength:rowLength)
            }else if(face == .Up){//rotate
                self.facesItemsPositions[face] = self.executeRotation(arrayData: self.getFaceNumericRepresentation(face: face)
                    , face: face, rotationOrientation:.OppClockWise, rotationsCount: ArrayRotationDegrees.D90.rawValue)
            }else if(face == .Down){
                //first we reverse rows, than rotate face
                var newArray = Array<Int>.init()
                let rowLength = face == .Left || face == .Right ? self.baseHeight! : self.baseWidth!
                let reversedResult = self.reverseRowsFor(arrayData: self.getFaceNumericRepresentation(face: face),rowsCount:rowLength,rowLength:rowLength)
                for n in 0..<self.baseWidth*self.baseHeight{
                    newArray.append(reversedResult[n]!)
                }
                self.facesItemsPositions[face] = self.executeRotation(arrayData:newArray , face: face, rotationOrientation: .OppClockWise, rotationsCount: ArrayRotationDegrees.D90.rawValue )
            }else{//normal obtained representatoion based on my order to see faces index order: see images
                self.facesItemsPositions[face] = self.assoicatePositionToItemIndexRepresentation(face: face)
            }
            lastValue4UniqueValues  = self.createFaceUniqueIdentifiers(lastValueUsed: lastValue4UniqueValues, face: face)
            
        }
        
    }
    /*rotation last approach start here
     i alrready have each face (item,position), rotating a column or row must be as simple as get 4 face involved in rotation and change items positions, each face neiborg wil get data of previus face depending in move orientation
     */
    func getFacesInvolvedInRotation(faceOfMoveOrigin:Face,columnMove:cubeColumnMove,moveOrigin:MoveOrigin)->Array<Face>{
        //faceOfMoveOrigin:like touched face in a move to pivote for moving, they are  supposed to be append in order
        var faces = Array<Face>()
        faces.append(faceOfMoveOrigin)
        var lastFace = faceOfMoveOrigin
        let item = CubeItem()
        for _ in 1...3{
            let f = item.rotations[columnMove]![moveOrigin]![lastFace]!
            faces.append(f)
            lastFace = f
        }
        return faces
    }
    func getColumnRowPositionAfterRotationOf(degrees:degrees)->[Int:Int]{//column/row 1 for 90 dgrss wil move to 2, [1:2,2:3,3:4,4:1]etc
        guard degrees != .D360 else{
            return [:]
        }
        var res:[Int:Int] = [:]
        let advaceBy = degrees.rawValue
        for n in 0..<4{
            res[n] = (n < (4-advaceBy) ? n+advaceBy:advaceBy-(4-n))
            
        }
        return res
        
    }
    
    //is the rubik solve?
    func isSolved()->Bool{//mising,unfnished,pendent
        let solved = false
        return solved
    }
    func ROTATE(faceOfMoveOrigin:Face,columnMove:cubeColumnMove,moveOrigin:MoveOrigin,index:Int,degrees:degrees) throws->[Int:CubeColor]{
        //have to document how only a faceOfMoveOrigin have sence for some columnMove and moveOrigin like side vertical only for origin face right or left
        do {
            let facesInvolved =  self.getFacesInvolvedInRotation(faceOfMoveOrigin: faceOfMoveOrigin, columnMove: columnMove, moveOrigin: moveOrigin)
            guard facesInvolved.count == 4 else{
                return [:]
            }
            var uniquePositionsColors:[Int:CubeColor] = [:]
            let newPositionsToColumns =  self.getColumnRowPositionAfterRotationOf(degrees:degrees)
            var orientation = RotationOrientation.ClockWise
            var itemsToBeOverride:[Int:CubeItem] = [:]
            var rotatedItems:Array<Int> = Array<Int>.init()
            var avoiding = Array<Int>.init()
            let realIndexPosition:[Int:Int] = self.itemsRealIndex
            for i in 0..<facesInvolved.count{
                var actualRotatedItems:Array<Int> = Array<Int>.init()
                let originFaceData:(Array<Int>,[Int:Int])!
                var destinyFaceData:(Array<Int>,[Int:Int])!
                var tempUniquePositionsColors:[Int:CubeColor] = [:]
                if (columnMove == .Vertical || columnMove == .VerticalP){
                    originFaceData = self.getColumnOf(face: facesInvolved[i], columnNumber:index,moveOrigin:moveOrigin,cubeColumnMove:columnMove)
                    destinyFaceData = self.getColumnOf(face: facesInvolved[newPositionsToColumns[i]!], columnNumber:index,moveOrigin:moveOrigin,cubeColumnMove:columnMove)
                }else{
                    originFaceData = self.getRowOf(face: facesInvolved[i], rowNumber: index,moveOrigin:moveOrigin,cubeColumnMove:columnMove)
                    destinyFaceData = self.getRowOf(face: facesInvolved[newPositionsToColumns[i]!], rowNumber: index,moveOrigin:moveOrigin,cubeColumnMove:columnMove)
                }
                orientation = columnMove == .VerticalP || columnMove == .HorizontalP ? RotationOrientation.OppClockWise:orientation
                if (i > 0 && i < facesInvolved.count-1){
                    avoiding.append(destinyFaceData.0[0])//para remover jiro redundante
                }
                if (i==facesInvolved.count-1){
                    avoiding.append(destinyFaceData.0[0])
                    avoiding.append(destinyFaceData.0[destinyFaceData.0.count-1])
                }
                (itemsToBeOverride,actualRotatedItems,tempUniquePositionsColors) = try self.exchangeFaces(origin: originFaceData.0, originItems: originFaceData.1, destination: destinyFaceData.0, destinationItems: destinyFaceData.1, columnMove:columnMove,fromFace:facesInvolved[i],toFace:facesInvolved[newPositionsToColumns[i]!],degrees:degrees,moveOrigin:moveOrigin,items: itemsToBeOverride,avoiding: avoiding,alreadyRotatedItems:rotatedItems,itemRealIndex:realIndexPosition)
                rotatedItems+=actualRotatedItems
                for key in tempUniquePositionsColors.keys{
                    uniquePositionsColors[key] = tempUniquePositionsColors[key]
                }
                avoiding.removeAll()//not  used
            }
            return uniquePositionsColors
        }catch{
            return [:]
        }
    }
    //update
    func getItemsRealIndexWith(value:Int,inDict:[Int:Int])->Int?{
        for x in inDict.enumerated(){
            if x.element.value == value{
                return x.element.key
            }
        }
        return nil
    }
    func exchangeFaces(origin:Array<Int>,originItems:[Int:Int ],destination:Array<Int>, destinationItems:[Int:Int],columnMove:cubeColumnMove,fromFace:Face,toFace:Face,degrees:degrees,moveOrigin:MoveOrigin,items:[Int:CubeItem],avoiding:Array<Int>,alreadyRotatedItems:Array<Int>,itemRealIndex:[Int:Int] ) throws ->([Int:CubeItem],Array<Int>,[Int:CubeColor]){
        var uniquePositionsColors:[Int:CubeColor] = [:]
        var rotatedItems:Array<Int> = Array<Int>.init()
        var itemsToBeOverride:[Int:CubeItem] = items
        for i in destinationItems.keys{
            if alreadyRotatedItems.contains(destinationItems[i]!){
                continue
            }
            itemsToBeOverride[destinationItems[i]!] = self.cubeItems[destinationItems[i]!]
            rotatedItems.append(destinationItems[i]!)
            self.cubeItems[destinationItems[i]!]=itemsToBeOverride[originItems[i]!] != nil ? itemsToBeOverride[originItems[i]!]! : self.cubeItems[originItems[i]!]
            self.itemsRealIndex[getItemsRealIndexWith(value:originItems[i]!,inDict:itemRealIndex)!] = getItemsRealIndexWith(value:itemRealIndex[destinationItems[i]!]!,inDict:itemRealIndex)!//update
            let vectorDirections = self.cubeItems[destinationItems[i]!].proccessRotation(degrees: degrees, direction: columnMove, moveOrigin:moveOrigin)
            for key in vectorDirections.keys{
                if let v = self.faceUniqueIdentifiers[key]?[destinationItems[i]!]{
                    uniquePositionsColors[v] = vectorDirections[key]
                    self.identifierAsociatedFace[v] = key
                }
            }
        }
        return (itemsToBeOverride,rotatedItems,uniquePositionsColors)
    }
    //update
    func getRealIdentifierFromStatickCube(uniqueIdentifier:Int,index:Int)->Int?{
        var identifierResult:Int? = nil
        guard self.cubeItemsUniqueIdentifier[index] != nil else{
            return nil
        }
        guard let realIndex = self.itemsRealIndex[index] else{
            return nil
        }
        var targetFace:Face? = nil
        for vector in self.cubeItems[index].vectors{
            if vector.uniqueIdentifier == uniqueIdentifier{
                targetFace = vector.vectorDirection
            }
        }
        for vector in self.cubeItems[realIndex].vectors{
            if vector.vectorDirection == targetFace{
                identifierResult = vector.uniqueIdentifier
            }
        }
        return identifierResult
    }
    //update
    func getAdyacentStickersAtSameFaceFor(uniqueIdentifier:Int)->Array<(itemIndex:Int,identifier:Int)>{
        guard let itemIndex = self.identifierAsociatedItem[uniqueIdentifier] else{
            return []
        }
        guard let realIndex = self.itemsRealIndex[itemIndex] , let identifierFace = self.cubeItems[realIndex].getUniqueItemVectorDirectionByUniqueIdentifier(identifier: uniqueIdentifier)  else{
            return []
        }
        var adyacentStickers:Array<(itemIndex:Int,identifier:Int)> = Array<(Int,Int)>.init()
        for adyacentItem in self.getAdyacentItemsfor(Index: realIndex).enumerated(){
            if let adyacentItemIndex = adyacentItem.element.value{
                if let adyacentFaceIdentifier = self.getIdentifierPointingOfItemAt(index:adyacentItemIndex,toFace:identifierFace){
                    adyacentStickers.append((itemIndex:adyacentItemIndex,identifier:adyacentFaceIdentifier))
                }
            }
        }
        return adyacentStickers
    }
    
    //update
    func getIdentifierPointingOfItemAt(index:Int,toFace face:Face)->Int?{
        guard let realIndex = self.itemsRealIndex[index] else{
            return nil
        }
        return self.cubeItems[realIndex].getVectorPointingTo(face: face)
        /*for identifier in uniqueIdentifiers{
         if (self.cubeItems[index].getUniqueItemVectorDirectionByUniqueIdentifier(identifier: identifier) == face){
         return identifier
         }
         }
         return nil*/
    }
    
    //update
    func assignUniqueIdentifiersToCubeItemsVectors(){
        for i in 0..<self.cubeItems.count{
            for j in 0..<self.cubeItems[i].vectors.count{
                self.cubeItems[i].vectors[j].uniqueIdentifier = self.faceUniqueIdentifiers[self.cubeItems[i].vectors[j].vectorDirection]![i]
            }
        }
    }
    func setItemUniformColor(index:Int,color:CubeColor){
        guard index < self.baseWidth*self.baseHeight*self.cubeHeight else{
            return
        }
        self.cubeItems[index].setItemAsUniformColor(color:color)
        
    }
    func getInitialColorForUniqueIdentifiers()->Dictionary<Int,CubeColor
        >{//initial color must be set if consuming this func, validate that
            var result:[Int:CubeColor] = [:]
            for face in self.faces{
                for (_,val) in self.getColorForIdentifiersInitialCube(face: face).enumerated(){
                    result[val.key] = val.value
                }
            }
            return result
    }
    func getColorForIdentifiersInitialCube(face:Face)->Dictionary<Int,CubeColor>{
        var result:Dictionary<Int,CubeColor> = [:]
        var initialColor:CubeColor? = nil
        if let initColors = self.facesInitialColors[face]{
            if initColors.count > 0{
                initialColor = initColors[0]
            }else{
                return [:]
            }
        }
        guard let faceIdemtifiers = self.faceUniqueIdentifiers[face] else{
            return [:]
        }
        for (_,val) in faceIdemtifiers.enumerated(){
            result[val.value] = initialColor
        }
        return result
    }
    func getColumnOf(face:Face,columnNumber:Int,moveOrigin:MoveOrigin,cubeColumnMove:cubeColumnMove)->(Array<Int>,[Int:Int]){
        var data = self.facesItemsPositions[face]
        var localcubeColumnMove =  cubeColumnMove == .VerticalP ? .Vertical : cubeColumnMove
        localcubeColumnMove =  localcubeColumnMove == .HorizontalP ? .Horizontal : localcubeColumnMove
        if (self.itemsPositiosForRotations[localcubeColumnMove]?[moveOrigin]?[face] != nil){
            data = self.itemsPositiosForRotations[localcubeColumnMove]?[moveOrigin]?[face]
        }
        guard let faceItems  = data else{
            return ([],[:])
        }
        var columnPositions = Array<Int>()
        let position = columnNumber - 1
        var itemsPositions = [Int:Int]()
        for i in 0..<self.baseHeight{
            columnPositions.append(position+self.baseWidth*i)
            itemsPositions[position+self.baseWidth*i] = faceItems[position+self.baseWidth*i]
        }
        return (columnPositions,itemsPositions)
    }
    
    func getRowOf(face:Face,rowNumber:Int,moveOrigin:MoveOrigin,cubeColumnMove:cubeColumnMove)->(Array<Int>,[Int:Int]){
        var data = self.facesItemsPositions[face]
        if (self.itemsPositiosForRotations[cubeColumnMove]?[moveOrigin]?[face] != nil){
            data = self.itemsPositiosForRotations[cubeColumnMove]?[moveOrigin]?[face]
        }
        guard let faceItems  = data else{
            return ([],[:])
        }
        var itemsPositions = [Int:Int]()
        var columnPositions = Array<Int>()
        let position = (rowNumber - 1)*self.baseWidth//
        for i in 0..<self.baseWidth{
            columnPositions.append(position+i)
            itemsPositions[position+i] = faceItems[position+i]
        }
        return (columnPositions,itemsPositions)
    }
    //rotating approach ends here
    

    func setFacesIndexData(){
        for face in self.faces{
            self.facesIndexData[face] = self.getFaceNumericRepresentation(face: face)
        }
    }
    //brings an specific face index(of the cube) in an array(it is use for faces)
    func getFaceNumericRepresentation(face:Face)->Array<Int>{
        guard let faceColRowPos = self.faceColRowPos[face] else{
            return []
        }
        switch face {
        case Face.Front,Face.Back:
            return self.getSideVerticalColumn(columnNumber: faceColRowPos)
        case Face.Up,Face.Down:
            return  self.getHorizontalCollumn(columnNumber: faceColRowPos)
        default:
            return self.getVerticalColumn(columnNumber: faceColRowPos)
        }
    }
    //a generic function, to get necesary initial representation of the cube items state
    func getColumnNumericRepresentation(columnPos:Int,moveOrigin:MoveOrigin,cubeColumnMove:cubeColumnMove)->Array<Int>{
        if moveOrigin == .Frontal && (cubeColumnMove == .VerticalP || cubeColumnMove == .Vertical){
            return self.getVerticalColumn(columnNumber: columnPos)
        }
        else if moveOrigin == .Frontal  && (cubeColumnMove == .Horizontal || cubeColumnMove == .HorizontalP){
            return  self.getHorizontalCollumn(columnNumber: columnPos)
        }
        else{
            return self.getSideVerticalColumn(columnNumber: columnPos)
        }
    }
    func getPartsCount()->[partType:Int]{//now only
        return [.Corner:8,.Arist:self.cubeUnitsZise-8-self.faces.count,.Center:self.faces.count*((self.baseWidth-2)*(self.cubeHeight-2)),]//fix for not equal faces cube
    }
    //brings just corners and centers, otherwise, they are arist
    func setItemsAndPartsPositions(){
        self.partsPositions[partType.Corner] = self.CreateCornerIntemsAndgetFaceCornerPeacesPositions()
        self.partsPositions[partType.Center] = self.CreateCenterIntemsAndgetFaceCenterPeacesPositions()
        //arist still missing""
        
    }
    /*if i get the pocitions of a fece centers, no need to do it again, just use getFaceNumericRepresentation func,and  with the same indexs for every out layer
     (may be more efficient if we return cubeItems from here enstead of only the index they centers will be, or best , set  item of the index with values in here )*/
    func CreateCornerIntemsAndgetFaceCornerPeacesPositions()->Array<Int>{
        /*
         0:2,0,7
         */
        let corners_increment = (baseHeight*self.baseWidth)*(self.cubeHeight-1)//for top corners
        self.createCornerItemAt(index: 0, vData: [(Face.Front,self.baseWidth-1),(Face.Down,self.baseWidth*self.baseHeight-1),(Face.Right,0)])//face 1
        self.createCornerItemAt(index: self.baseHeight-1, vData: [(Face.Right,self.baseHeight-1),(Face.Down,self.baseWidth-1),(Face.Back,0)])//face 2
        self.createCornerItemAt(index: (self.baseHeight*self.baseWidth)-self.baseHeight, vData: [(Face.Front,0),(Face.Left,self.baseHeight-1),(Face.Down,(self.baseHeight*self.baseWidth)-self.baseWidth)])//face 3
        self.createCornerItemAt(index: self.baseHeight*self.baseWidth-1, vData: [(Face.Left,0),(Face.Down,0),(Face.Back,self.baseWidth-1)])//face 4
        self.createCornerItemAt(index: 0+corners_increment, vData: [(Face.Front,self.baseWidth*self.baseHeight-1),(Face.Right,(self.baseHeight*self.cubeHeight)-self.baseHeight),(Face.Up,self.baseWidth-1)])//face 5
        self.createCornerItemAt(index:self.baseHeight-1+corners_increment, vData: [(Face.Right,(self.baseHeight*self.cubeHeight)-1),(Face.Up,(self.baseWidth*self.baseHeight)-1),(Face.Back,(self.baseWidth*self.cubeHeight)-self.baseWidth)])//face 6
        self.createCornerItemAt(index: (self.baseHeight*self.baseWidth)-self.baseHeight+corners_increment, vData: [(Face.Front,(self.baseWidth*self.baseHeight)-self.baseWidth),(Face.Left,self.baseHeight*self.baseHeight-1),(Face.Up,0)])//face 7
        self.createCornerItemAt(index: self.baseHeight*self.baseWidth-1+corners_increment, vData: [(Face.Left,(self.baseHeight*self.baseHeight)-self.baseHeight),(Face.Up,(self.baseWidth*self.baseHeight)-self.baseWidth),(Face.Back,self.baseWidth*self.cubeHeight-1)])//face 8
        var res:Array<Int> = [0,self.baseHeight-1,(self.baseHeight*self.baseWidth)-self.baseHeight,self.baseHeight*self.baseWidth-1]
        res.append(corners_increment)
        res.append(self.baseHeight-1+corners_increment)
        res.append((self.baseHeight*self.baseWidth)-self.baseHeight+corners_increment)
        res.append(self.baseHeight*self.baseWidth-1+corners_increment)
        return res
    }
    func getFakeItemsPositions()->Array<Int>{//not real peaces, in a 3x3x3 like 13, 4x4x4 =  21,22,
        var result = Array<Int>()
        var position = self.baseWidth*self.baseHeight+self.baseHeight+1//13 for 3x3x3, 21 for 4x4x4
        for i in 1..<self.cubeHeight-1{
            for _ in 1..<self.baseWidth-1{
                for _ in 1..<self.baseHeight-1{
                    result.append(position)
                    position+=1
                }
                position+=3
            }
            position = (self.baseWidth*self.baseHeight)*(i+1)+self.baseHeight+1
        }
        return result
    }
    func createCornerItemAt(index:Int,vData:Array<(face:Face,facePosition:Int)>){
        let corner = CubeItem(cubePart: partType.Corner)
        var itemVectors = Array<Vector>()
        for faceData in vData{
            itemVectors.append(Vector.init(vectorDirection: faceData.face, color: self.facesInitialColors[faceData.face]![faceData.facePosition], base: self.isBase(face: faceData.face)))
        }
        corner.setVectorsWith(data: itemVectors)
        self.cubeItems[index] = corner
    }
    func CreateCenterIntemsAndgetFaceCenterPeacesPositions()->Array<Int>{
        var result = Array<Int>()
        var position = self.baseWidth+1
        var oneFaceCenters = Array<Int>()
        for i in 1..<self.cubeHeight-1{
            for _ in 1..<self.baseWidth-1{
                oneFaceCenters.append(position)
            }
            position=i*self.baseWidth+1
        }
        for face in self.faces{
            let xFace = self.getFaceNumericRepresentation(face: face)
            for centerPos in oneFaceCenters{
                let cubeItem = CubeItem(cubePart: .Center)
                var itemVectors = Array<Vector>()
                result.append(xFace[centerPos])
                itemVectors.append(Vector.init(vectorDirection: face, color: self.facesColor[face]!, base: self.isBase(face: face)))
                cubeItem.setVectorsWith(data: itemVectors)
                self.cubeItems[xFace[centerPos]] = cubeItem
                
            }
            
            
        }
        return result
    }
    func setFacesInitialColors(){
        self.facesInitialColors[.Front] = Array<CubeColor>()
        self.facesInitialColors[.Right] = Array<CubeColor>()
        self.facesInitialColors[.Up] = Array<CubeColor>()
        self.facesInitialColors[.Left] = Array<CubeColor>()
        self.facesInitialColors[.Back] = Array<CubeColor>()
        self.facesInitialColors[.Down] = Array<CubeColor>()
        /*self.facesInitialColors[.Front] = Array.init(repeating: .White, count: self.baseWidth*self.cubeHeight)
         self.facesInitialColors[.Right] = Array.init(repeating: .Red, count: self.baseHeight*self.cubeHeight)
         self.facesInitialColors[.Up] = Array.init(repeating: .Blue, count: self.baseHeight*self.baseHeight)
         self.facesInitialColors[.Left] = Array.init(repeating: .Yellow, count: self.baseHeight*self.cubeHeight)
         self.facesInitialColors[.Back] = Array.init(repeating: .Orange, count: self.baseWidth*self.cubeHeight)
         self.facesInitialColors[.Down] = Array.init(repeating: .Green, count: self.baseHeight*self.baseHeight)*/
        /*Firs Scramble
         self.facesInitialColors[.Front] = [.Yellow,.Yellow,.Blue,.White,.Green,.Blue,.White,.Orange,.Red]
         self.facesInitialColors[.Right] = [.Red,.Blue,.Blue,.Red,.Red,.White,.Green,.Green,.Orange]
         self.facesInitialColors[.Up] = [.Blue,.Yellow,.Yellow,.Yellow,.White,.Orange,.Red,.Red,.White]
         self.facesInitialColors[.Left] = [.Orange,.Orange,.Blue,.Red,.Orange,.Green,.Green,.Blue,.Orange]
         self.facesInitialColors[.Back] = [.Orange,.Red,.Yellow,.Orange,.Blue,.Yellow,.Green,.Green,.White]
         self.facesInitialColors[.Down] = [.Green,.White,.Yellow,.Blue,.Yellow,.White,.Red,.Green,.White]
         */
        /*self.facesInitialColors[.Front] = [.Orange,.Yellow,.Yellow,.Blue,.Green,.Orange,.White,.White,.White]
         self.facesInitialColors[.Right] = [.Green,.Red,.Red,.Green,.Red,.Yellow,.Orange,.Red,.Yellow]
         self.facesInitialColors[.Up] = [.Red,.Blue,.Green,.Blue,.White,.Yellow,.Yellow,.Green,.Red]
         self.facesInitialColors[.Left] = [.Yellow,.Blue,.White,.Green,.Orange,.Yellow,.Blue,.Red,.Blue]
         self.facesInitialColors[.Back] = [.Green,.Orange,.Green,.Green,.Blue,.Red,.Blue,.White,.Orange]
         self.facesInitialColors[.Down] = [.Orange,.White,.White,.Orange,.Yellow,.White,.Blue,.Orange,.Red]*/
        self.facesInitialColors[.Front] = [.Blue,.Blue,.Blue,.Blue,.Blue,.Blue,.Blue,.Blue,.Blue]
        self.facesInitialColors[.Right] = [.Red,.Red,.Red,.Red,.Red,.Red,.Red,.Red,.Red]
        self.facesInitialColors[.Up] = [.Yellow,.Yellow,.Yellow,.Yellow,.Yellow,.Yellow,.Yellow,.Yellow,.Yellow]
        self.facesInitialColors[.Left] = [.Orange,.Orange,.Orange,.Orange,.Orange,.Orange,.Orange,.Orange,.Orange]
        self.facesInitialColors[.Back] = [.Green,.Green,.Green,.Green,.Green,.Green,.Green,.Green,.Green]
        self.facesInitialColors[.Down] = [.White,.White,.White,.White,.White,.White,.White,.White,.White]
    }
    func createCubeFromScreensShots(){
        //becauce is a cube, to determinate the state from images, only edges will need of two or three faces to determinate the state of a cube item, inner items only have a vector(color)
        //we will calculate every row of the cube, we loop from 0 to cubeHeight-1 wich is
        var aristPositions:Array<Int> =  Array.init()
        self.setItemsAndPartsPositions()//.arist and .center positioon in cube already save
        let fakeItemsPos = self.getFakeItemsPositions()
        for i in 0..<self.baseWidth*self.baseHeight*self.cubeHeight{
            if (self.cubeItems[i].type == nil){//if nil, is because  this index is not set yet, so is .arist, an alternative way is look for self.cubeItems[i] in self.partsPositions[.Corner] and self.partsPositions[.Center] if not there, is an .Arist
                if !fakeItemsPos.contains(i){//si no es una posicion falsa
                    aristPositions.append(i)
                    self.calculateFacesAndColorFor(index:i,partType:.Arist)//only calculate arist, consider removing parameter in function
                }else{
                    print("Fake Item=====================> \(i)")//doesn't exist
                }
            }
        }
        self.partsPositions[partType.Arist]  = aristPositions
        self.assignUniqueIdentifierToCubeItem()
        
        self.assignUniqueIdentifiersToCubeItemsVectors()//update
    }
    func setCoordinatesOfItems(){
        let fakePos = self.getFakeItemsPositions()
        for i in 0..<self.cubeItems.count{
            if !fakePos.contains(i){
                self.calculatePositionForItem(itemIndex: i, part: self.cubeItems[i].type)
            }
        }
    }
    
    //this function returns the item type at an specific postion
    func getTypeOfItemAt(index:Int)->partType?{
        guard index < self.cubeItems.count else{
            return nil
        }
        return self.cubeItems[index].type!
    }
    
    //position in a grid with width*height
    func calculatePositionForItem(itemIndex index:Int, part:partType){
        if part == .Corner{//cornes are at (1,1) coordenates by default
            self.itemsCoordenates[index] = (1,1)
            return
        }
        let sideHalf = Int(self.baseWidth/2)
        var positionAtFace:Int? = nil
        facesLoop: for face in self.faces{
            if let itemsPositions = self.facesItemsPositions[face]{
                for (_,keyVal) in itemsPositions.enumerated(){
                    if  keyVal.value == index{
                        positionAtFace = keyVal.key
                        break facesLoop//once found in any face, it will be enought to find positio at grid,(corners are at 3 faces, arist at 2 ad centers at 1)
                    }
                }
            }
        }
        if var pAF = positionAtFace{
            pAF = pAF+1//not base 0, most clear
            var row:Float = ceil(Float(pAF)/Float(self.baseWidth))
            var column:Float = Float(self.baseWidth) - (Float(self.baseWidth)*row - Float(pAF))
            if Int(column) > (sideHalf+1){
                column = Float(self.baseWidth) - column + 1
            }
            if Int(row) > (sideHalf+1){
                row = Float(self.baseWidth) - row + 1
            }
            self.itemsCoordenates[index] = (Int(row),Int(column))
        }
        
    }
    
    //determinate if a face is been use as a base
    func isBase(face:Face)->Bool{
        return self.base.face == face ? true:false
    }
    /*this function  given a index of the cube, will return the faces and respective colors for this faces, expl. centers will have one vector and tha same color of the face .
     it may be only use for partType.arist, nut sure now.
     i have to doit arist by arist becouse arist are the remaining from other peaces(centesr and corners)*/
    func calculateFacesAndColorFor(index:Int,partType:partType){
        let cubeItem = CubeItem(cubePart: partType)
        var itemVectors = Array<Vector>()
        if partType == .Arist{
            var foundedFaceVectors = 0
            for face in faces{
                if self.facesIndexData[face] == nil{
                    continue
                }
                for item in self.facesItemsPositions[face]!{
                    if item.value == index{
                        //we will found a match 2 times for each arist
                        //to get the index(to get the color in this face) i use a variable that will count from 0 to the number that represents the
                        //aristData[]
                        itemVectors.append(Vector.init(vectorDirection: face, color: self.facesInitialColors[face]! [item.key], base: self.isBase(face: face)))
                        foundedFaceVectors+=1
                    }
                }
                if foundedFaceVectors == Int(partType.rawValue){//we have found all vector for actual arist, we are done
                    continue
                }
            }
        }
        cubeItem.setVectorsWith(data: itemVectors)
        self.cubeItems[index] = cubeItem
        
    }
    //brings the entire column,""
    func getVerticalColumn(columnNumber:Int)->Array<Int>{
        var result = Array<Int>()
        var i = 0
        while(i<self.cubeHeight){
            for n in 0..<baseWidth{
                result.append(i*baseWidth*baseHeight+n+columnNumber*baseWidth)
            }
            i=i+1
            
        }
        return result
    }
    
    //brings every individual row of an specific column as an array
    func getHorizontalColumnAsArray(columnNumber:Int)->Array<Array<Int>>{
        var result  = Array<Array<Int>>()
        var i = 0
        while(i<cubeHeight){
            var columnLine = Array<Int>()
            for n in 0..<baseWidth{
                //columnLine.append(cubeItems[i*baseWidth*baseHeight]+n+columnNumber*baseWidth)
                columnLine.append(i*baseWidth*baseHeight+n+columnNumber*baseWidth)
            }
            i=i+1
            result.append(columnLine)
        }
        return result
    }
    //havin a column, get ortogonal columns or verical columns from a side, of the enire cube
    func getSpecificHorizontalColumnAsArray(columnNumber:Int,row:Int)->Array<Int>{
        var result = Array<Int>()
        for column in getHorizontalColumnAsArray(columnNumber:columnNumber){
            result.append(column[row-1])
        }
        return result
    }
    //of the entire club
    func getSpecificVerticalColumnAsArray(columnNumber:Int,row:Int)->Array<Int>{
        if (self.cubeItems.count >  columnNumber){
            return []
        }
        return getHorizontalColumnAsArray(columnNumber:columnNumber)[row-1]
    }
    
    //-------------------------------1END---------------------------------
    //having a pespective front,considering the a side , gets the vertical column(first column 0,0+1,0+2 ), of the entire cube
    func getSideVerticalColumn(columnNumber:Int)->Array<Int>{
        var result = Array<Int>()
        for n in 0..<self.cubeHeight*self.baseHeight{
            result.append(n*baseHeight+columnNumber)
        }
        return result
    }
    //of the entire cube
    func getHorizontalCollumn(columnNumber:Int)->Array<Int>{
        var result = Array<Int>()
        for n in 0..<self.baseWidth*self.baseHeight{
            result.append(columnNumber*baseWidth*baseHeight+n)
        }
        return result
    }
    
    //this tree functions,cconbinated  can give you a 3D ubication of a peace/item of the cube bieng: getRowForItemAt the 'X'axis,getColumnForItemAt te 'Z' axis and getSideColumnForItemAt is 'Y',
    func getRowForItemAt(Index:Int)->Int?{
        guard Index < self.baseWidth*self.baseHeight*self.cubeHeight else{
            return nil
        }
        return Int(floor(Double((Index)/(self.baseWidth*self.baseHeight))))
    }
    
    func getSideColumnForItemAt(Index:Int)->Int?{
        guard Index < self.baseWidth*self.baseHeight*self.cubeHeight else{
            return nil
        }
        let residuo = (Index) % baseWidth
        return residuo
    }
    func getColumnForItemAt(Index:Int)->Int?{
        guard Index < self.baseWidth*self.baseHeight*self.cubeHeight else{
            return nil
        }
        let b = Index - Int(floor(Double((Index)/(self.baseWidth*self.baseHeight))))*self.baseWidth*self.baseHeight
        return Int(ceil(Double(b/(self.baseHeight))))
    }
    func get3DCoordenatesOfItemAt(index:Int)->(x:Int,y:Int,z:Int){
        //if index use base Cero, remove next line
        //index+=1
        return (x:self.getColumnForItemAt(Index:index)!,y:self.getSideColumnForItemAt(Index:index)!,z:self.getRowForItemAt(Index:index)!)
    }
    /*it finds all adyasent items to an specific item*/
    func getAdyacentItemsfor(Index:Int)->[AdyacentItemPosition:Int?]{
        guard let column = self.getColumnForItemAt(Index:Index) else {
            return [:]
        }
        guard let sideColumn = self.getSideColumnForItemAt(Index:Index) else {
            return [:]
        }
        guard let row = self.getRowForItemAt(Index:Index) else{
            return [:]
        }
        let right:Int? = column == 0 ? nil : Index - self.baseHeight
        let left:Int? = column == (self.baseWidth-1) ? nil : Index + self.baseHeight
        let up:Int? = row == (self.cubeHeight-1) ? nil : Index + self.baseWidth*self.cubeHeight
        let down:Int? = row == 0 ? nil : Index - self.baseWidth*self.cubeHeight
        let back:Int? = (sideColumn  == 0 ) ? nil : Index - 1
        let front:Int? = (sideColumn == (self.baseWidth-1) ) ? nil : Index + 1
        return [AdyacentItemPosition.Right:right,AdyacentItemPosition.Left:left,AdyacentItemPosition.Up:up,AdyacentItemPosition.Down:down,AdyacentItemPosition.Back:back,AdyacentItemPosition.Front:front]
    }
    func verifyIfArrayContainsAnyItemOf(targets:Array<Int>,Array:Array<Int>)->Bool{
        for n in targets{
            if Array.contains(n){
                return true
            }
        }
        return false
    }
    func getItemsOf(type:partType,inFace:Face)->Array<Int>{
        var result:Array<Int> = Array.init()
        let faceNumericRepresentation = self.getFaceNumericRepresentation(face: inFace)
        let centerItemsIndex = self.partsPositions[type]
        result = faceNumericRepresentation.matchingItemsOf(target: centerItemsIndex!)
        return result
    }
    func getFaceOf(color:CubeColor)->Face{
        /*
         if is a corner, need to find the 3 faces to generate a coordenate of the item at a right position
         if is an arist, just need 2 faces to compare
         if dimensions of the cube are ood/impar one position can give us the final and only one cpmparassing criteria, othr wise,
         like 4x4x4 center are composed by 4 peaces, the color of this center would be the most repeated color in this 4 peaces, and thereor for a nxnxn cube with
         bxbxb peaces a the center
         */
        var result:Face!
        let validationWithOneItem = self.baseWidth % 2 == 0 ? false : true
        var max = 0
        for face in self.faces{
            var contOfColors = 0
            var centerItemsIndex = getItemsOf(type:.Center,inFace:face)
            if validationWithOneItem{
                centerItemsIndex = [centerItemsIndex.sorted()[centerItemsIndex.count/2]]
            }
            for index in centerItemsIndex{
                let item = self.cubeItems[index]
                if item.vectors[0].color == color{//index 0 because we are sure index will alway have only one
                    contOfColors+=1
                }
            }
            if contOfColors > max{
                result = face
            }
            max = contOfColors > max ? contOfColors : max
        }
        return result
        
    }
    
    func findFacesForRightPositions(index:Int)->Array<Face>{
        var faces:Array<Face> = Array.init()
        let colors = self.cubeItems[index].getColors()
        for color in colors{
            faces.append(self.getFaceOf(color: color))
        }
        return faces
    }
    func findFacesAdyacentTo(index:Int)->Array<Face>{
        var faces:Array<Face> = Array.init()
        for face in self.faces{
            if self.facesItemsPositions[face]!.contains(where: {$1 == index}){
                faces.append(face)
            }
        }
        return faces
    }
    
    func faceOfUniqueIdentifierWith(index:Int)->String?{
        for face in self.faces{
            if (self.faceUniqueIdentifiers[face]!.contains(where: ({
                if ($1==index){
                    return true
                }
                return false
            }))){
                return String(face.rawValue)
            }
            
        }
        return nil
    }
    func findItemRightPositions(index:Int)->Array<Int>{
        var rightPos:Array<Int> =  Array.init()
        let facesToTriangle = self.findFacesForRightPositions(index: index)
        //first get the items the are part of items of each face(convergecy if is a corner shoul alwalys be one,if arist  width-2)
        
        var allCommonItems:Array<Int> = Array.init()
        for i in 0..<facesToTriangle.count-1{
            if i == 0{
                allCommonItems = self.getFaceNumericRepresentation(face: facesToTriangle[i])
            }
            allCommonItems = allCommonItems.merge(target: self.getFaceNumericRepresentation(face: facesToTriangle[i+1]))
        }
        //over here, all items that are shared by the faces are stored in allCommonItems, but if an item is an arist, it can only be an in specific row or column
        if allCommonItems.count ==  1{
            return allCommonItems
        }
        let targetType = self.getTypeOfItemAt(index: index)
        let targetCoordenatesAtFace = self.itemsCoordenates[index]!
        for itemIndex in allCommonItems {
            self.calculatePositionForItem(itemIndex: itemIndex, part: self.getTypeOfItemAt(index: itemIndex)!)
            if  targetType == self.getTypeOfItemAt(index: itemIndex){
                if self.itemsCoordenates[itemIndex]! == targetCoordenatesAtFace || (self.itemsCoordenates[itemIndex]!.0 == targetCoordenatesAtFace.1 &&  self.itemsCoordenates[itemIndex]!.1 == targetCoordenatesAtFace.0){
                    rightPos.append(itemIndex)
                }
            }
        }
        return rightPos
    }
    /*given a item index, Find the item(s) that should/may be here for us to solve the  cube */
    func findRightItemForPositionAt(index:Int)->Array<Int>{
        guard index < self.cubeItems.count else{
            return []
        }
        var rightItemsIndexes:Array<Int> =  Array.init()
        var targetColors:Array<CubeColor> = Array.init()
        
        for face in findFacesAdyacentTo(index:index){
            for color in self.colors{
                if self.getFaceOf(color: color) == face{
                    targetColors.append(color)
                    continue
                }
            }
        }
        if let partType = self.getTypeOfItemAt(index: index){
            if let indexOfPartsOfTheSameType = self.partsPositions[partType]{
                for itemIndex  in indexOfPartsOfTheSameType{
                    if self.cubeItems[itemIndex].getColors().totallyContains(target: targetColors){
                        rightItemsIndexes.append(itemIndex)
                    }
                }
            }
        }
        return rightItemsIndexes
    }
    /*
     based in the fact that we know what are the dimensions of the cube and we know where unique identifiers asignation starts, note this will work if we know the order
     faces are stored in var faces:Array<Face>!, i have ordered them self.faces = [.Front,.Back,.Down,.Left,.Right,.Up], but is not required, just consider this for this function
     */
    func getUniqueIdentifierFace(identifier:Int)->Face?{
        let faceIdenitiersCount = self.cubeHeight*self.baseWidth
        guard identifier >= self.uniqueIdentifiersStartPosition && identifier <=  self.uniqueIdentifiersStartPosition + (faceIdenitiersCount*self.faces.count) else{
            return nil
        }
        let identifiersTotal = Float(self.faces.count*faceIdenitiersCount)
        let ratio =  Float(identifier - self.uniqueIdentifiersStartPosition - 1) / identifiersTotal
        return self.faces[Int(floor((ratio)*Float(self.faces.count)))]
    }
    
    /*
     it tells me if an item can be an equivalent of another, but maybe in another face, aonther column, row, side column, in other words, if they both could be exchanged(placed in the other actual place)
     in both directions
     */
    func determinateIfPositionsAreMirroring(itemAtX3DIndex:Int,itemAtY3DIndex:Int)->Bool{
        let itemsCount = self.cubeItems.count
        guard itemAtX3DIndex < itemsCount && itemAtY3DIndex < itemsCount else{
            return false
        }
        let firstItem = self.cubeItems[itemAtX3DIndex]
        let secondItem = self.cubeItems[itemAtY3DIndex]
        guard firstItem.type  == secondItem.type else{
            return false
        }
        if (partType.Corner == firstItem.type || itemAtX3DIndex == itemAtY3DIndex){//corners  can alway be excanged in any combination
            return true
        }
        if let coordenatesOfXinFace = itemsCoordenates[itemAtX3DIndex],let coordenatesOfYinFace = itemsCoordenates[itemAtY3DIndex]{
            if(coordenatesOfXinFace.0 == coordenatesOfYinFace.0 && coordenatesOfXinFace.1 == coordenatesOfYinFace.1) || (coordenatesOfXinFace.1 == coordenatesOfYinFace.0 && coordenatesOfXinFace.0 == coordenatesOfYinFace.1){
                return true
            }
        }
        
        
        return true
    }
    
    //this function tells me whenever the red face is pointing to front, up, back
    func getFaceDirectionByColor(color:CubeColor)->VectorDirection{
        var vectorDirection:VectorDirection!
        for face in self.faces{
            if (self.getFaceOf(color: color) == face){
                vectorDirection = face
            }
            break
        }
        return vectorDirection
    }
    //get the color of an specific item at any state, to an specific face
    func getColorOfItemInFace(itemIndex:Int,face:Face)->CubeColor?{
        for vector in self.cubeItems[itemIndex].vectors{
            if vector.vectorDirection == face {
                return vector.color
            }
        }
        return nil
    }
    
    
    func determinateIfPatternExist(constraints:[CubeColor:Array<(CubeColor,(Int,Int))>])->(Bool,Array<Int>){//patterns need the entire cube to be set wih a color
        /*if i want to know, for example, initial white cross is set, all i will have to pass is a set of constraint like (white face, must have, 4 arist with white color)
         exclude oposite face(oppsit of white), and all other faces must have an arist with an arist of that face color, the will determinate that thre is a cross, for nxnxn probably i most evaluate (col,and row)
         */
        var evaluatedItemsIndexs:Array<Int> = Array.init()
        for data in constraints.enumerated(){
            let face = self.getFaceOf(color: data.element.key)
            guard let itemsAtFace = self.facesItemsPositions[face] else{
                return (false,[])
            }
            var evaluatedItems:Array<Int> = Array.init()
            for x in data.element.value{
                var found = false
                for itemIndex in itemsAtFace.enumerated(){
                    guard !evaluatedItems.contains(itemIndex.element.value) else{
                        continue
                    }
                    let colorOfItenInFace = self.getColorOfItemInFace(itemIndex: itemIndex.element.value, face: face)
                    if colorOfItenInFace == x.0{
                        if let itemCoordenates = self.itemsCoordenates[itemIndex.element.value]{
                            if itemCoordenates == x.1 || itemCoordenates == (x.1.1,x.1.0){//because is a mirror grid, inverses can be at the same space in grid
                                found = true
                                evaluatedItems.append(itemIndex.element.value)
                                if (self.cubeItems[itemIndex.element.value].type != .Center){
                                    evaluatedItemsIndexs.append(itemIndex.element.value)
                                }
                                break
                            }
                        }
                    }
                }
                if !found{
                    return (false,[])
                }
                //evaluatedItems.removeAll()
            }
            
        }
        return (true,evaluatedItemsIndexs)
    }
    //useful for cases like red,green,orange,blue... etc cross, this one is based in right positions of items that, consider that we have to verify each peace colors to be "pointing" to right face, because findItemRightPositions just tell me if there is the right position
    func determinateIfPatternExist(faceColor:CubeColor,partType:partType,numberOfPartsToValidate:Int?)->Bool{
        let face = self.getFaceOf(color: faceColor)
        let (rightItemsIndexes,itemsAtFace) = validateIfItemsAreAtRightPositionOf(face:face,partType:partType)
        let itemsToValidate = numberOfPartsToValidate == nil ? itemsAtFace : numberOfPartsToValidate!
        guard (rightItemsIndexes.count > 0 && rightItemsIndexes.count >= itemsToValidate) else {return false}
        var itemsAteightPositionAtRightWithRightColors = 0
        for  itemsIndex in  rightItemsIndexes{
            //have to verify that each item at a certain face of color X has the color X as well,using yellow cross 4 example means every arist in the yellow color must be yellow
            let colorOfItemAtface = self.getColorOfItemInFace(itemIndex: itemsIndex, face: face)
            if (colorOfItemAtface == faceColor){
                itemsAteightPositionAtRightWithRightColors+=1
            }
        }
        guard itemsAteightPositionAtRightWithRightColors >= itemsToValidate else{
            return false
        }
        return true
    }
    func getColorOppositeOf(color:CubeColor)->CubeColor?{
        return self.facesOppositeColors[color]
    }
    func determinateIfPatternExistToAdyacentOf(faceColor:CubeColor,partType:partType,numberOfPartsToValidate:Int?)->Bool{
        let actualcolor = faceColor
        let oppositColor = self.facesOppositeColors[faceColor]!
        for color in self.colors{
            if (color != actualcolor && color != oppositColor){
                if !(self.determinateIfPatternExist(faceColor: color, partType: partType, numberOfPartsToValidate: numberOfPartsToValidate)){
                    return false
                }
            }
        }
        return true
    }
    func isItemInTheSameColumnAndRow(firstItemIndex:Int,secondItemIndex:Int)->Bool{
        let firstItem3DPosition = self.get3DCoordenatesOfItemAt(index: firstItemIndex)
        let secondItem3DPosition = self.get3DCoordenatesOfItemAt(index: secondItemIndex)
        if ((firstItem3DPosition.x == secondItem3DPosition.x && firstItem3DPosition.y
            == secondItem3DPosition.y) || (firstItem3DPosition.x == secondItem3DPosition.x
                && firstItem3DPosition.z == secondItem3DPosition.z) || (firstItem3DPosition.y == secondItem3DPosition.y
                    && firstItem3DPosition.z == secondItem3DPosition.z)){
            return true
        }
        return false
    }
    //x & y  x & z
    //tells me of items of a certain type at a certain face, are at right positions,return count of items of this type a
    func validateIfItemsAreAtRightPositionOf(face:Face,partType:partType)->(Array<Int>,Int){
        let itemsIndexes = self.getItemsOf(type: partType, inFace: face)
        var rightItemsIndexes:Array<Int> = []
        for index in itemsIndexes{
            if (self.findItemRightPositions(index: index).contains(index)){
                rightItemsIndexes.append(index)
            }
        }
        
        return (rightItemsIndexes,itemsIndexes.count)
    }
    
    func generateStateOfTheCube()->[CubeColor:Array<(CubeColor,(Int,Int))>]{
        var pattern:[CubeColor:Array<(CubeColor,(Int,Int))>] = [:]
        for color in self.colors{//colors of the cube, need to be updated and need to
            let face = self.getFaceOf(color: color)
            var colorsAndUbications:Array<(CubeColor,(Int,Int))> = Array.init()
            for item in self.facesItemsPositions[face]!.enumerated(){
                colorsAndUbications.append((self.getColorOfItemInFace(itemIndex: item.element.value, face: face)!,self.itemsCoordenates[item.element.value]!))
            }
            pattern[color] = colorsAndUbications
        }
        return pattern
    }
    
    func getColumnOfItemAt(index:Int)->Array<Int>{
        let column:Array<Int> = Array<Int>.init()
        
        return column
    }
    
    func getColumnAndRowForItemAt(index:Int)->Array<Int>{
        return findAdyacentItemsAtSameRowOrColumnOFor(alreadyFoundItems:[index],itemsToEvaluate:[index],pivotIndex:index)
        
    }
    func findAdyacentItemsAtSameRowOrColumnOFor(alreadyFoundItems:Array<Int>,itemsToEvaluate:Array<Int>,pivotIndex:Int)->Array<Int>{
        var alreadyFoundItemsCopy:Array<Int> = alreadyFoundItems
        var adyacentItems:Array<Int> = []
        for itemIndex in itemsToEvaluate{
            let adyacentIndex = self.getAdyacentItemsfor(Index: itemIndex)
            for adyacent in adyacentIndex.enumerated(){
                if adyacent.element.value != nil{
                    if (self.getColumnForItemAt(Index: pivotIndex) == self.getColumnForItemAt(Index: adyacent.element.value!) ||
                        self.getRowForItemAt(Index: pivotIndex) == self.getRowForItemAt(Index: adyacent.element.value!) || self.getSideColumnForItemAt(Index: pivotIndex) == self.getSideColumnForItemAt(Index: adyacent.element.value!)){
                        if !alreadyFoundItemsCopy.contains(adyacent.element.value!){
                            alreadyFoundItemsCopy.append(adyacent.element.value!)
                            adyacentItems.append(adyacent.element.value!)
                        }
                    }
                }
            }
        }
        let faceItemsCount = self.baseWidth*self.baseHeight
        let x = faceItemsCount-(self.baseWidth*2 - 1)
        if (alreadyFoundItemsCopy.count != (faceItemsCount + (faceItemsCount - self.baseWidth) + x)){
            alreadyFoundItemsCopy = findAdyacentItemsAtSameRowOrColumnOFor(alreadyFoundItems:alreadyFoundItemsCopy,itemsToEvaluate:adyacentItems,pivotIndex:pivotIndex)
        }
        return alreadyFoundItemsCopy
    }
    
    
    func findAdyacentItemsAtSameRowOrColumnOForIdentifiedByAName(alreadyFoundItems:Array<String>,itemsToEvaluate:Array<Int>,pivotIndex:Int)->Array<String>{
        var alreadyFoundItemsCopy:Array<String> = alreadyFoundItems
        var adyacentItems:Array<Int> = []
        for itemIndex in itemsToEvaluate{
            let adyacentIndex = self.getAdyacentItemsfor(Index: itemIndex)
            for adyacent in adyacentIndex.enumerated(){
                if adyacent.element.value != nil{
                    if (self.verifyIfTwoItemsAreAtTheSame(firstItemIndex:pivotIndex,
                                                          secondItemIndex:adyacent.element.value!,compareFunction: self.getColumnForItemAt)){
                        if (!alreadyFoundItemsCopy.contains("\(MobileElement.column.rawValue)_\(adyacent.element.value!)")){
                            alreadyFoundItemsCopy.append("\(MobileElement.column.rawValue)_\(adyacent.element.value!)")
                            adyacentItems.append(adyacent.element.value!)
                        }
                    }
                    if (self.verifyIfTwoItemsAreAtTheSame(firstItemIndex:pivotIndex,
                                                          secondItemIndex:adyacent.element.value!,compareFunction: self.getRowForItemAt)){
                        if (!alreadyFoundItemsCopy.contains("\(MobileElement.row.rawValue)_\(adyacent.element.value!)")){
                            alreadyFoundItemsCopy.append("\(MobileElement.row.rawValue)_\(adyacent.element.value!)")
                            adyacentItems.append(adyacent.element.value!)
                        }
                    }
                    if (self.verifyIfTwoItemsAreAtTheSame(firstItemIndex:pivotIndex,
                                                          secondItemIndex:adyacent.element.value!,compareFunction: self.getSideColumnForItemAt)){
                        if (!alreadyFoundItemsCopy.contains("\(MobileElement.sideColumn.rawValue)_\(adyacent.element.value!)")){
                            alreadyFoundItemsCopy.append("\(MobileElement.sideColumn.rawValue)_\(adyacent.element.value!)")
                            adyacentItems.append(adyacent.element.value!)
                        }
                    }
                }
            }
        }
        if (alreadyFoundItemsCopy.count != (self.baseWidth*self.baseHeight*self.cubeHeight)){
            alreadyFoundItemsCopy = findAdyacentItemsAtSameRowOrColumnOForIdentifiedByAName(alreadyFoundItems:alreadyFoundItemsCopy,itemsToEvaluate:adyacentItems,pivotIndex:pivotIndex)
        }
        return alreadyFoundItemsCopy
    }
    func isThereACubeItemAt(itemIndex:Int)->Bool{
        guard self.cubeItems.count > itemIndex else{
            return false
        }
        return true
    }
    func verifyIfTwoItemsAreAtTheSame(firstItemIndex:Int,secondItemIndex:Int,compareFunction:(Int)->Int?)->Bool{
        if (compareFunction(firstItemIndex) == compareFunction(secondItemIndex)){
            return true
        }
        return false
    }
    func getIndexOfPosibleMovesFor(itemIndex:Int)->Array<String>{
        guard self.isThereACubeItemAt(itemIndex: itemIndex) else{
            return []
        }
        return self.findAdyacentItemsAtSameRowOrColumnOForIdentifiedByAName(alreadyFoundItems: [], itemsToEvaluate: [itemIndex], pivotIndex: itemIndex)
    }
    func getMobileElementItemsNameFor(itemIndex:Int,mobileElement:MobileElement)->Array<Int>{
        let indexOfPosibleMoves = self.getIndexOfPosibleMovesFor(itemIndex:itemIndex)
        var itemIndex:Array<Int> = Array<Int>.init()
        for element in indexOfPosibleMoves{
            if (element.contains(mobileElement.rawValue)){
                let char = CharacterSet(charactersIn: String("_"))
                itemIndex.append(Int(element.components(separatedBy: char)[1])!)
            }
        }
        return itemIndex
    }
    func getItemActualLocationBy(uniqueIdentifier:Int)->Int?{
        for i in 0..<self.cubeItems.count{
            if let cubeItemsUniqueIdentifiers = self.cubeItemsUniqueIdentifier[i]{
                if (cubeItemsUniqueIdentifiers.contains(uniqueIdentifier)){
                    return i
                }
            }
        }
        return nil
    }
    func findAdyacentStickerOnFaceForStickerWIth(uniqueIdentifier:Int)->Array<Int>{
        let adyacentStickerAtFace:Array<Int> = Array<Int>.init()
        //let index = self.findItemLocationByColorsUsing(uniqueIdentifier:uniqueIdentifier)
        //let alreadyCalc = self.identifierAsociatedItem[uniqueIdentifier]
        return adyacentStickerAtFace
    }
    /*func getAdyacentItemsForItemWithUniqueIdentifier(uniqueIdentifier:Int)->Array<Int>{
     guard let itemIndex = self.getItemActualLocationBy(uniqueIdentifier: uniqueIdentifier)  else{
     return []
     }
     let touchFace:Face = self.faceOfUniqueIdentifierWith(index: uniqueIdentifier)
     let adyacentItems = self.getAdyacentItemsfor(Index: itemIndex)
     for item in adyacentItems.keys{
     for identifier in adyacentItems[key]
     }
     }*/
    func findItemLocationByColorsUsing(uniqueIdentifier:Int)->Int?{
        for i in 0...self.cubeItems.count{
            if let identifiers = self.cubeItemsUniqueIdentifier[i]{
                if identifiers.contains(uniqueIdentifier){
                    return i
                }
            }
        }
        return nil
    }
    /*func getMobileElementForItemAtIndex()->MobileElement{
     
     }*/
    //July 10
    func getCompletePercent()->Double{
        var contator:Int = 0
        let fakeItemPositions:Array<Int> = self.getFakeItemsPositions()
        for index in 0..<self.baseWidth*self.baseHeight*self.cubeHeight{
            if !fakeItemPositions.contains(index){
                let t = self.findItemRightPositions(index: index)
                if t.contains(index){
                    let itemsVectorCounts:Int = self.cubeItems[index].vectors.count
                    var vectorInRightPosition:Int = 0
                    for color in self.cubeItems[index].getColors(){
                        let faceInColor:Face = self.getFaceOf(color: color)
                        if color == self.getColorOfItemInFace(itemIndex: index, face: faceInColor){
                            vectorInRightPosition+=1
                        }
                    }
                    if vectorInRightPosition == itemsVectorCounts{
                        contator+=1
                    }
                    
                }
            }
        }
        return 100.0*(Double(contator)/20.0)
    }
    func getCubeItemColorsByUniqueIdentifierBy(itemIndex:Int)->[Int:CubeColor]{
        var result:[Int:CubeColor] = [:]
        let itemsIdentifiers = self.getItemAsociatedIdentifiers(index: itemIndex)
        let vectors = self.cubeItems[itemIndex].vectors
        
        for identifier in itemsIdentifiers{
            let uniqueIdentifierFace = self.getUniqueIdentifierFace(identifier: identifier)
            for face in vectors!{
                if (uniqueIdentifierFace == face.vectorDirection){
                    let color = self.getColorOfItemInFace(itemIndex: itemIndex, face: face.vectorDirection)
                    result[identifier] = color
                }
            }
        }
        
        return result
    }
    func getRightItemInIndex(index:Int)->Int?{
        for rightItems in self.itemsRealIndex.enumerated(){
            if rightItems.element.value == index{
                return rightItems.element.key
            }
        }
        return nil
    }
    func getRandomUNiqueIdentifiers(count:Int)->Array<Int>{
        var result:Array<Int> = Array<Int>.init()
        for _ in 0..<count{
            let range = self.getUniqueidentifiersRange()
            let identifier:Int = range.start + Int(arc4random_uniform(UInt32(range.end - range.start)))
            result.append(identifier)
        }
         return result
    }
    func setRandomStickersToUniformColor(count:Int){
        let indexes:Array<Int> = getRandomUNiqueIdentifiers(count:count)
        let _ = self.cubeItems.map({ (item:CubeItem) in
            let _ = item.vectors.map({ (vector:Vector) in
                if (indexes.contains(vector.uniqueIdentifier!)){
                   vector.setUniforColor(color: CubeColor.Gray)
                }
            })
        })
    }
    func getOppositeCorners()->[Int:Int]{
        let totalPeaces:Int = self.cubeItems.count
        let basePeacesCount:Int = self.baseWidth*self.baseHeight
        return [0:basePeacesCount-1,
                self.baseWidth-1:self.baseWidth*(self.baseHeight-1),
            basePeacesCount*(self.cubeHeight-1):totalPeaces-1,
                           basePeacesCount*(self.cubeHeight-1)+self.baseWidth-1:totalPeaces-self.baseWidth]
    }
    func setStickersToUniformColorForDeterministicColorFinding(count:Int?){
        //let oppositeCorners = self.getOppositeCorners()
        let _ = self.cubeItems.map({ (item:CubeItem) in
            guard item.type == partType.Arist else{
                return
            }
            let vectorIndex = Int(arc4random_uniform(UInt32(item.vectors.count-1)))
            item.vectors[vectorIndex].setUniforColor(color: CubeColor.Gray)
        })
    }
    func getColorOf(face:Face)->CubeColor?{
        var color:CubeColor? = nil
        let itemsAtFace = self.getFaceNumericRepresentation(face: face)
        let _ = itemsAtFace.map({ index in
            if (self.cubeItems[index].type == partType.Center){
                color = self.getColorOfItemInFace(itemIndex: index, face: face)
                return
            }
        })
        return color
    }
    func getCubeFacesInRandomOrder()->Array<Face>{
        var result:Array<Face> = Array<Face>.init()
        var indexesAvailable:Array<Int> = Array<Int>.init()
        for i in 0..<self.faces.count{
            indexesAvailable.append(i)
        }
        while indexesAvailable.count > 0{
            let index = Int(arc4random_uniform(UInt32(indexesAvailable.count-1)))
            result.append( self.faces[indexesAvailable[ index ]])
            let _ = indexesAvailable.remove(at: index)
        }
        return result
    }
    func setStickersToUniformColorForArist(count:Int)->(colors:[CubeColor:Int],vectors:Array<Vector>,data:[Int:CubeColor]){
        var colorsData:[CubeColor:Int] = [:]
        var vectorsData:Array<Vector> = []
        var proccessedIndexes:Array<Int> = Array<Int>.init()
        var proccessedColors:Array<CubeColor> = Array<CubeColor>.init()
        let totalAristToBeProccesed = (self.baseWidth - 1)*6 - 2
        let aristCount = (self.baseWidth-2)*2
        let faceTreshHold = count >= 12 ? aristCount : aristCount/2
        var data:[Int:CubeColor] = [:]
        let evaluateRepeatedColors:Bool = count >= 12 ? false : true
        let _ = self.faces.map({ (face:Face) in
            guard proccessedIndexes.count != totalAristToBeProccesed else{
                return
            }
            let arists = returnArrayWithValueRandomlyReordered(targetArray: self.getItemsOf(type: .Arist, inFace: face))
            let faceColor = self.getColorOf(face:face)
            var sameFaceColorItemCount = 0
            let _ = arists.map({ arist in
                
                if (sameFaceColorItemCount < faceTreshHold){
                    let vectors:Array<Vector> = self.cubeItems[arist].vectors
                    var vectorCount = 0
                    let _ = vectors.map({ vector in
                        let otherVector = vectors[vectorCount == 0 ? 1 : 0]
                        if (vector.color == faceColor && !proccessedIndexes.contains(arist) && !proccessedColors.contains(otherVector.color)){
                            proccessedIndexes.append(arist)
                            if evaluateRepeatedColors{
                                proccessedColors.append(otherVector.color)
                            }
                            vectorsData.append(otherVector)
                            data[arist] = vector.color
                            if let value = colorsData[otherVector.color] {
                                colorsData[otherVector.color] = value + 1
                            }else{
                                colorsData[otherVector.color] =  1
                            }
                            sameFaceColorItemCount+=1
                        }
                        vectorCount+=1
                    })
                }
            })
        })
       return (colorsData,vectorsData,data)
    }
    func getCenterPeaceOpposite(index:Int)->Int?{
        guard index < self.baseWidth*self.baseHeight*self.cubeHeight,let indexColumn = self.getColumnForItemAt(Index: index),let indexRow = self.getRowForItemAt(Index: index),let sideColumn = self.getSideColumnForItemAt(Index: index) else{
            return nil
        }
        let item = self.cubeItems[index]
        var result:Int? = nil
        let itemFace = item.vectors[0].vectorDirection
        let faceItems:Array<Int> = self.facesIndexData[self.facesOpposites[itemFace!]!]!
        let _ = faceItems.map({ itemIndex in
           
            let column = self.getColumnForItemAt(Index: itemIndex)
            let row = self.getRowForItemAt(Index: itemIndex)
            let sColumn = self.getSideColumnForItemAt(Index: itemIndex)
            if ((column == indexColumn) && (row == indexRow) || ((column == indexColumn) && (sColumn == sideColumn)) || ((sColumn == sideColumn) && (row == indexRow))){
                result = itemIndex
                return
            }
        })
        return result
    }
    func setStickersToUniformColorForCorners()->(colors:[CubeColor:Int],vectors:Array<Vector>,data:[Int:CubeColor]){
        var colorsData:[CubeColor:Int] = [:]
        var vectorsData:Array<Vector> = []
        var proccessedColors:Array<CubeColor> = Array<CubeColor>.init()
        let cornersOppositeIndexes = self.getOppositeCorners()
        var data:[Int:CubeColor] = [:]
        for corner in cornersOppositeIndexes.enumerated(){
            
            guard let vectorsCorner = self.cubeItems[corner.element.key].vectors, let vectorsOppositeCorner = self.cubeItems[corner.element.value].vectors else{
                return ([:],[],[:])
            }
            for i in 0..<3{
                if (!proccessedColors.contains(vectorsCorner[i].color)){
                    vectorsData.append(vectorsCorner[i])
                    proccessedColors.append(vectorsCorner[i].color)
                    data[corner.element.key] = vectorsCorner[i].color
                    if let value = colorsData[vectorsCorner[i].color]{
                        colorsData[vectorsCorner[i].color] = value + 1
                    }else{
                        colorsData[vectorsCorner[i].color] = 1
                    }
                    break
                }
                if (!proccessedColors.contains(vectorsOppositeCorner[i].color)){
                    vectorsData.append(vectorsOppositeCorner[i])
                    data[corner.element.key] = vectorsOppositeCorner[i].color
                    proccessedColors.append(vectorsOppositeCorner[i].color)
                    if let value = colorsData[vectorsOppositeCorner[i].color]{
                        colorsData[vectorsOppositeCorner[i].color] = value + 1
                    }else{
                        colorsData[vectorsOppositeCorner[i].color] = 1
                    }
                    break
                }
            }
        }
        return (colorsData,vectorsData,data)
    }
    func setStickersToUniformColorForCenters()->(colors:[CubeColor:Int],vectors:Array<Vector>,data:[Int:CubeColor]){
        var colorsData:[CubeColor:Int] = [:]
        var vectorsData:Array<Vector> = []
        let option = Int(arc4random_uniform(UInt32(2)))
        var data:[Int:CubeColor] = [:]
        let randomizedFaces:Array<Face> = returnArrayWithValueRandomlyReordered(targetArray: self.faces)
        for i in 0..<4{
            let face = randomizedFaces[i]
            let _ = self.getItemsOf(type: .Center, inFace: face).map({ itemIndex in
                if let oppositeIndex = self.getCenterPeaceOpposite(index:itemIndex){
                    let realIndex = option == 0 ? oppositeIndex : itemIndex
                    vectorsData.append(self.cubeItems[realIndex].vectors[0])
                    let rightIndex = option == 0 ? oppositeIndex : itemIndex
                    data[rightIndex] = self.cubeItems[rightIndex].vectors[0].color
                    if let value = colorsData[self.cubeItems[rightIndex].vectors[0].color]{
                         colorsData[self.cubeItems[rightIndex].vectors[0].color] = value + 1
                    }else{
                         colorsData[self.cubeItems[rightIndex].vectors[0].color]  = 1
                    }
                }
            })
        }
        return (colorsData,vectorsData,data)
    }
    func setStickersToUniformColorForDeterministicColorFindingFace(count:Int)->(colors:[CubeColor:Int],vectors:Array<Vector>,data:[String:CubeColor]){
        
        var result:[CubeColor:Int] = [CubeColor.Blue:0,CubeColor.Green:0,CubeColor.Orange:0,CubeColor.White:0,CubeColor.Yellow:0,CubeColor.Red:0]
        var data:[String:CubeColor] = [:]
        let aristData:(colors:[CubeColor:Int],vectors:Array<Vector>,data:[Int:CubeColor]) = self.setStickersToUniformColorForArist(count:count)
        let cornersData:(colors:[CubeColor:Int],vectors:Array<Vector>,data:[Int:CubeColor]) = self.setStickersToUniformColorForCorners()
        let centersData:(colors:[CubeColor:Int],vectors:Array<Vector>,data:[Int:CubeColor]) = self.setStickersToUniformColorForCenters()
        var countAppliedColors = 0
        var vectorsFiltered:Array<Vector> = Array<Vector>.init()
        let randomizedArist = returnArrayWithValueRandomlyReordered(targetArray: aristData.vectors)
        let randomizedCorners = returnArrayWithValueRandomlyReordered(targetArray: cornersData.vectors)
        let randomizedCenters = returnArrayWithValueRandomlyReordered(targetArray: centersData.vectors)
        let randomizedValues = returnArrayWithValueRandomlyReordered(targetArray: [randomizedArist,randomizedCorners,randomizedCenters])
        for vectors in randomizedValues{
            for vector in vectors{
                if (countAppliedColors < count){
                    vector.setUniforColor(color: CubeColor.Gray)
                    countAppliedColors+=1
                    result[vector.color] = result[vector.color]! + 1
                    vectorsFiltered.append(vector)
                    data["\(self.identifierAsociatedItem[vector.uniqueIdentifier!]!)"] = vector.color
                }
            }
        }
        //self.whereIsColor()
        return (result,vectorsFiltered,data:data)
    }
    func getCubeColorRelationGiven(identifiers:Array<Int>)->(colors:[CubeColor:Int],vectors:Array<Vector>,data:[String:CubeColor]){
        var dataResult:[String:CubeColor] = [:]
        var colors:[CubeColor:Int] = [CubeColor.Blue:0,CubeColor.Green:0,CubeColor.Orange:0,CubeColor.White:0,CubeColor.Yellow:0,CubeColor.Red:0]
        var vectors:Array<Vector> = Array<Vector>.init()
        for identifier in identifiers{
           
            if let itemIndex = self.getItemActualLocationBy(uniqueIdentifier: identifier){
                for vector in self.cubeItems[itemIndex].vectors{
                    if (vector.uniqueIdentifier == identifier){
                        colors[vector.color] = colors[vector.color]! + 1
                        vectors.append(vector)
                        dataResult["\(itemIndex)"] = vector.color
                        vector.setUniforColor(color: CubeColor.Gray)
                    }
                }
            }
        }
        self.whereIsColor()
        return (colors:colors,vectors:vectors,data:dataResult)
    }
    func getCubeColorRelationGiven(data:[String:String])->(colors:[CubeColor:Int],vectors:Array<Vector>,data:[String:CubeColor]){
        var dataResult:[String:CubeColor] = [:]
        var colors:[CubeColor:Int] = [CubeColor.Blue:0,CubeColor.Green:0,CubeColor.Orange:0,CubeColor.White:0,CubeColor.Yellow:0,CubeColor.Red:0]
        var vectors:Array<Vector> = Array<Vector>.init()
        for item in data.enumerated(){
            if let itemIndex = Int(item.element.key){
                for vector in self.cubeItems[itemIndex].vectors{
                    if (vector.color.rawValue == item.element.value){
                        colors[vector.color] = colors[vector.color]! + 1
                        vectors.append(vector)
                        dataResult["\(itemIndex)"] = vector.color
                        vector.setUniforColor(color: CubeColor.Gray)
                    }
                }
            }
            
        }
        self.whereIsColor()
        return (colors:colors,vectors:vectors,data:dataResult)
    }
    func whereIsColor(){
        for item in self.cubeItems{
            for n in item.vectors{
                if n.color == CubeColor.Gray{
                    print(n.uniqueIdentifier!)
                }
            }
        }
    }
    
}
