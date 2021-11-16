//
//  enums.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 23/6/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation
import UIKit

enum TimerKind:String{
    case normal = "N"
    case rubik = "R"
    case prepare = "P"
}
enum TimerState:Int{
    case running = 1
    case paused = 2
    case stopped = 3
}
//rubik model native enums
enum cubeColumnMove{//representas a move that a column of the cube can make, using a cube face as a reference
    case Vertical//having the cube whit white face in front, red at right and blue up,  this move means moving in clock needles orientation
    case VerticalP
    case Horizontal
    case HorizontalP
    
}
enum ArrayRotationDegrees:Int{
    case D0 = 0
    case D90 = 1
    case D180 = 2
    case D270 = 3
}
enum MoveOrigin{//if white face is in front,red at right and red at top, a frontal origin move would be rotate self.baseWidth rows
    case Frontal
    case Side
}
enum MobileElement:Character{
    case row = "R"
    case column = "C"
    case sideColumn = "S"
}
enum CubeColor:String{
    //main/clasic
    case Red = "Red"
    case Blue = "Blue"
    case White = "White"
    case Green = "Green"
    case Orange = "Orange"
    case Yellow = "Yellow"
    //end clasic clolors
    //help/guide/tutorial colors
    case Gray = "Gray"
    case Black = "Black"
}
enum VectorDirection:Character{//represents the vector direction, using on a front face as a base
    case Front = "F"
    case Back = "B"
    case Right = "R"
    case Left = "L"
    case Down = "D"
    case Up =  "U"
}

enum partType:Int8{
    case Center = 1//this assosiated number represents the number of colors(vector for me) this tems has visibles
    case Corner = 3
    case Arist = 2
}
enum degrees:Int{//degrees that a cube column/row cam turn
    case D90 = 1
    case D180 = 2
    case D270 = 3
    case D360 = 0//the same as a clock orientation opposite move, a 90 degrees move
}

enum RotationOrientation:Int{
    case ClockWise = 1
    case OppClockWise = 2
}

//end rubik model native enums


enum rotatonArrowsTilt:Int{
    case T45
    case T135
    case T225
    case T315
}
enum methodState:String{
    case waiting = "Waiting"
    case stopped = "Stopped"
    case inProgress = "In Progress"
    case learned = "Learned"
}

enum recordingState:Int{
    case stoped = 0
    case recording = 1
    case paused = 2
}

enum rightPositionHint:Int{
    case showing = 1
    case sleeping = 0
}

enum Axis:String{
    case x = "x"
    case y = "y"
    case z = "z"
}

enum SquareSector:String{
    case I = "I"
    case II = "II"
    case III = "III"
    case IV = "IV"
}

enum Sign:Int{
    case positive = 1
    case negative = -1
}
enum levelState:Int{
    case inProggress = 1
    case complete = 2
    case waiting = 3
}
enum Game:Int{
    case paintAndSolve = 1
    case paint = 2
}
enum SolvedCountState:Int{
    case updated = 1
    case outdate = 0
}
enum GameDifficultyLevel:Int{
    case brave = 0
    case alpha_male = 1
    case legend = 2
    func toString()->String{
        switch self.rawValue {
            case 0:
                return "brave"
            case 1:
                return "alfa-male"
            default:
                return "legend"
        }
    }
}
