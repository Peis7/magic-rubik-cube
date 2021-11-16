//
//  variable.swift
//  XTimer
//
//  Created by Pedro Luis Cabrera Acosta on 25/6/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

var FIRST_TIME_APP_SHOWS:Bool = false
var LEVELS_PER_DIFFICULTY:Int = 18
var FIRST_TIME_A_LEVEL_IS_LOAD:Bool = true
let DRAGGED_TEMPORAL_IMAGE_TAG = 201
let COLOR_OPTIONS_DISABLER_VIEW_TAG = 202
let RATE_ASK_TRESHHOLD = 300
var tagsCount:Int = 1000//for tags used for cube items images, that may be difficult to manage  manally
var UICubeColors:[CubeColor:UIColor] = [.Blue:UIColor(red: 25/255, green: 53/255, blue: 149/255, alpha: 1),.Green:UIColor.green,.Orange:UIColor.orange,.Red:UIColor.red,.White:UIColor.white,.Yellow:UIColor.yellow,.Gray:.gray,.Black:.black]
var CubeBaseColors:Array<UIColor> = [UIColor.blue,UIColor.green,UIColor.orange,UIColor.red,UIColor.white,UIColor.yellow]
var helpArrowsDirectionRelation:[cubeColumnMove:rotatonArrowsTilt] = [.Vertical:.T45,.Horizontal:.T315,.HorizontalP:.T135,.VerticalP:.T225]
var moveIdentifiers:[Int:String] = [1:"R",2:"L",3:"U",4:"B",5:"D",6:"F",7:"RPrime",8:"LPrime",9:"UPrime",10:"BPrime",11:"DPrime",12:"FPrime",13:"middleSide",14:"middleSidePrime",15:"middleFrontH",16:"middleFrontPrimeH",17:"middleFront",18:"middleFrontPrime"]
func speech(words:String,language:String){
    let utterance = AVSpeechUtterance(string: words)
    utterance.voice = AVSpeechSynthesisVoice(language: language)
    let synthesizer = AVSpeechSynthesizer()
    if synthesizer.isSpeaking{
        synthesizer.stopSpeaking(at: .immediate)
    }
    synthesizer.speak(utterance)
    
}

func getMoveDIrectionFromPanGesture(startPoint:CGPoint,endPoint:CGPoint)->cubeColumnMove{
    var angle:Double = 0
    var move:cubeColumnMove = cubeColumnMove.Horizontal
    let dx = endPoint.x - startPoint.x
    let dy = endPoint.y - startPoint.y
    angle = abs(Double((atan2(dy, dx) * 180.0)) / Double.pi)
    let angle2 = 90 - angle
    if (angle2 > 35 && angle2 < 75 && angle > 20 &&  angle < 40){
        if (startPoint.x*endPoint.x*endPoint.y < 0){
              move = cubeColumnMove.Vertical
        }
    }
    if (angle2 < -35 && angle2 > -75 && angle > 130 &&  angle < 155){
        if (startPoint.x*endPoint.x*endPoint.y < 0){
            move = cubeColumnMove.HorizontalP
        }else{
            move = cubeColumnMove.VerticalP
        }
    }
    return move
}


