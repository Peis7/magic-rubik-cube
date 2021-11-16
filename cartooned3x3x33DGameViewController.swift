//
//  cartooned3x3x33DGameViewController.swift
//  stackTimerPlus
//
//  Created by Pedro Luis Cabrera Acosta on 3/9/17.
//  Copyright © 2017 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit
import AVFoundation

struct helpArrowImageLocation{
    var x:Float!
    var y:Float!
    init(x:Float,y:Float){
        self.x = x
        self.y = y
    }
}
class cartooned3x3x33DGameViewController: UIViewController,UIDragInteractionDelegate{
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        return []
    }
    
   
    
    var colorOptions:[Int:UIColor] = [1:UIColor(red: 25/255, green: 53/255, blue: 149/255, alpha: 1),2:UIColor.red,5:UIColor.green,3:UIColor.orange,4:UIColor.white,6:UIColor.yellow]
    let colorOptionsTagsByColor:[UIColor:Int] = [UIColor.red:2,UIColor.green:5,UIColor.white:4,UIColor.yellow:6,UIColor.orange:3,UIColor(red: 25/255, green: 53/255, blue: 149/255, alpha: 1):1]
    var colorOptionsOriginalLocationInfo:[Int:(center:CGPoint,location:CGPoint)] = [:]
    var missingPeacesByColor:[UIColor:Int] = [UIColor.red:0,UIColor.green:0,UIColor.white:0,UIColor.yellow:0,UIColor.orange:0,UIColor(red: 25/255, green: 53/255, blue: 149/255, alpha: 1):0]
    var missingStickersTags:Array<Int> = Array<Int>.init()
    //imageviews that represent visible cubeitems visiblesticker area
    //Right Face Items
    
    
    @IBOutlet weak var trysLbl: UILabel!
    @IBOutlet weak var nextLevel: UIButton!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var yellowColorOption: UIView!
    @IBOutlet weak var greenColorOption: UIView!
    @IBOutlet weak var whiteColorOption: UIView!
    @IBOutlet weak var orangeColorOption: UIView!
    @IBOutlet weak var redColorOption: UIView!
    @IBOutlet weak var blueColorOption: UIView!
    @IBOutlet weak var colorsContainerView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var leftRotateEntireCubeAreaView: UIView!
    @IBOutlet weak var rightRotateEntireCubeAreaView: UIView!
    @IBOutlet weak var itemRightPos0: UIImageView!
    @IBOutlet weak var itemRightPos1: UIImageView!
    @IBOutlet weak var itemRightPos2: UIImageView!
    @IBOutlet weak var itemRightPos9: UIImageView!
    @IBOutlet weak var itemRightPos10: UIImageView!
    @IBOutlet weak var itemRightPos11: UIImageView!
    @IBOutlet weak var itemRightPos18: UIImageView!
    @IBOutlet weak var itemRightPos19: UIImageView!
    @IBOutlet weak var itemRightPos20: UIImageView!
    //Up face Items
    @IBOutlet weak var itemUpPos18: UIImageView!
    @IBOutlet weak var itemUpPos19: UIImageView!
    @IBOutlet weak var itemUpPos20: UIImageView!
    @IBOutlet weak var itemUpPos21: UIImageView!
    @IBOutlet weak var itemUpPos22: UIImageView!
    @IBOutlet weak var itemUpPos23: UIImageView!
    @IBOutlet weak var itemUpPos24: UIImageView!
    @IBOutlet weak var itemUpPos25: UIImageView!
    @IBOutlet weak var itemUpPos26: UIImageView!
    //Left FAce Items
    @IBOutlet weak var itemFrontPos0: UIImageView!
    @IBOutlet weak var itemFrontPos3: UIImageView!
    @IBOutlet weak var itemFrontPos6: UIImageView!
    @IBOutlet weak var itemFrontPos9: UIImageView!
    @IBOutlet weak var itemFrontPos12: UIImageView!
    @IBOutlet weak var itemFrontPos15: UIImageView!
    @IBOutlet weak var itemFrontPos18: UIImageView!
    @IBOutlet weak var itemFrontPos21: UIImageView!
    @IBOutlet weak var itemFrontPos24: UIImageView!
    //item items definition end
    
    @IBOutlet weak var levelCompletedLabel: UILabel!
    @IBOutlet weak var moreBtn: UIImageView!
    
    @IBOutlet weak var lblCOuntDonwToNextTryReduce: UILabel!
    @IBOutlet weak var levelName: UILabel!
    @IBOutlet weak var configIcon: UIImageView!
    @IBOutlet weak var replicatingStateActivityIndicator: UIActivityIndicatorView!
    var isCommingFromConfigView = false
    var turningEffect = true
    var assistantEffect = false
    var player : AVAudioPlayer?
    var lastMovedUniqueIdentifiers:Array<Int>!
    var movesHistorical:Array<Int>!
    var movesInverses:Dictionary<String,String>!
    var cubeScrableMove:cubeScrableMove!
    var Bokin3x3x3:RubikCube!
    var scrabler:Scrabler!
    var stateOfTheCube:State? = nil
    var stepIdentifier:String? = nil
    var movesCount:Int = 0
    var solveTimer:XTimer!
    var secondsCountAfterTry:Int = 0
    var allowedTrysTimer:XTimer!
    var solvedLevelsTimer:XTimer!
    var time: Double = 0
    var startTime:Double = 0
    var replicationCounter:Int = 0
    var shouldAddMove:Bool = true
    var shouldCountMove:Bool = true
    var isRecratingCubeState:Bool = false
    var isLoadingAFinishedLevel:Bool = false
    var undoIndexLocation:Int = 0
    var panRecognizerStartLocation:CGPoint = CGPoint()
    var panRecognizerEndLocation:CGPoint = CGPoint()
    var stickerGestureMovesEquivalentsByAngle:[Int:[cubeColumnMove:String]] = [:]
    var askRate:Bool = false
    var selectedColor:UIColor? = nil
    @IBOutlet weak var timeLbl: UILabel!
    var uniqueIdentifiersUnfound:Array<Int>!
    var selectedColorIndex:Int? = nil
    var score:Int = 0
    var wrongColorSelected:Int = 0
    var wrongTrys:Int = 0
    var draggedImageCenter:CGPoint? = nil
    var draggedImageIndex:Int? = nil
    var isLoadingView:Bool = true
    var performedRandomScramble:Bool = false
    var CUBE_TAGS_START_COUNT = 0
    var isCreatingANewLevel:Bool = false
    var completePercent:Double = 0.0
    var actualLevelCopy:GameDifficultyLevel = GameDifficultyLevel.legend
    var solvedCountState:SolvedCountState = SolvedCountState.outdate
    @IBOutlet weak var timesSolvedLbl: UILabel!
    var clockTime = 12
    var timeShouldTryToLoadSolvedData:Float = 0
    var shouldCountSolvePercentEvaluationForSolveCompletion:Bool = true
    var allowPaintTry:Bool = true
    var isRecreantingANonFinishedLevel:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDataOnLoad()
        CUBE_TAGS_START_COUNT = tagsCount
        self.actualLevelCopy = Config.shared.difficulty
        self.handleViewDidLoad()
        tagsCount = tagsCount+Bokin3x3x3.baseHeight*Bokin3x3x3.baseWidth*6+1
        self.score = Session.shared.level.foundPeacesIdentifiers.convertToJsonObject()?.count == nil ? 0 : Session.shared.level.foundPeacesIdentifiers.convertToJsonObject()!.count
        self.updateScoreLabel()
        self.addTapGestureToConfigButton()
        self.addTapGestureToMoreButton()
        
        self.tryToLoadDataFromServer()
        Level.sendMissingSolvedLevelsDataToTheServer()
    }
    func loadDataFromServer(){
            SolvedData.shared.getData()
    }
    func handleViewDidLoad(){
        let bokinItems = Array<CubeItem>()
        self.Bokin3x3x3 = RubikCube(baseWidth: 3, baseHeight: 3, cubeHeight: 3, uniqueIdentifiersStartPosition: CUBE_TAGS_START_COUNT, items: bokinItems )
        self.Bokin3x3x3.createCubeFromScreensShots()
        self.Bokin3x3x3.setCoordinatesOfItems()
        self.completePercent = self.Bokin3x3x3.getCompletePercent()
        self.setImagestags()
        self.addGestureRecognizers()
        self.setStickersToUniformColor(count:Session.shared.level.missingPeaces)
        self.addViewForLoading()
        self.putSolidColorToIndex()
        self.configColorOptionsView()
        self.isLoadingView = false
        self.nextLevel.isUserInteractionEnabled = true
        self.addTapGestureToNextLevelButton()
        self.removeViewForLoading()
        self.updateMissingPeacesForLevel()
        self.proccessAllImageToFindMissingColorsFinished()
        if FIRST_TIME_APP_SHOWS{
            FIRST_TIME_APP_SHOWS = false
        }
        self.updateLevelLabel(level:self.getLevelNumber())
        self.handleNextLevelButtonVisibility()
        
    }
    func initializeDataOnLoad(){
        self.solveTimer = XTimer(kind: .rubik)
        self.solvedLevelsTimer = XTimer(kind: .normal)
        self.allowedTrysTimer = XTimer(kind:.normal)
        self.movesHistorical = Array.init()
        self.lastMovedUniqueIdentifiers = Array.init()
        uniqueIdentifiersUnfound = Array<Int>.init()
        self.movesInverses = ["RPrime":"R","B":"BPrime","D":"DPrime","L":"LPrime","F":"FPrime","U":"UPrime","middleFront":"middleFrontPrime","middleSide":"middleSidePrime","middleFrontH":"middleFrontPrimeH"]
        self.scrabler = Scrabler(verticalMoves: ["L","LPrime","R","RPrime","U","UPrime","middleFront"], moves4Scrable: 20, horizontalMoves:["F","B","FPrime","BPrime","D","DPrime","middleSide"])
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.moreBtn.isUserInteractionEnabled = true
    }
    func handleNextLevelButtonVisibility(){
        self.nextLevel.isHidden = true
        if (self.areCurrentLevelConditionsSatisfied(level:Config.shared.difficulty)){
            self.showNextButton()
        }
    }
    func handleLoadingLevelFinishel(){
        if (self.areCurrentLevelConditionsSatisfied(level:Config.shared.difficulty)){
            self.showNextButton()
            self.disableAllColorOtions()
            self.solveTimer.stop()
            self.time = 0
            self.isLoadingAFinishedLevel = true
            self.playAudioEffect(fileName: "finishedLevel", format: "mp3")
            self.levelCompletedLabel.isHidden = false
        }
    }
    func addTapGestureToNextLevelButton(){
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleNextLevelTapped))
        self.nextLevel.isUserInteractionEnabled = true
        self.nextLevel.addGestureRecognizer(tapGesture)
     }
    func addTapGestureToConfigButton(){
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleIconTapped))
        self.configIcon.isUserInteractionEnabled = true
        self.configIcon.addGestureRecognizer(tapGesture)
    }
    func addTapGestureToMoreButton(){
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMoreButtonTap))
        self.moreBtn.isUserInteractionEnabled = true
        self.moreBtn.addGestureRecognizer(tapGesture)
    }
    @objc func handleMoreButtonTap() {
        self.actualLevelCopy = Config.shared.difficulty
        self.performSegue(withIdentifier: "mainToMoreViewControllerSegue", sender: self)
    }
    @objc func handleIconTapped(){
        self.updateSessionInfo()
        self.solveTimer.stop()
        self.isCommingFromConfigView =  true
        self.performSegue(withIdentifier: "configSegueIdentifier", sender: self)
    }
    @objc func handleNextLevelTapped(){
         self.levelCompletedLabel.isHidden = true
         self.nextLevel.isHidden = true
         self.solvedCountState = .outdate
         self.handleUserIsGonnaTryNextLevel()
    }
    override func viewDidAppear(_ animated: Bool) {
         self.setCenterToColorOptions()
         self.colorOptionsOriginalLocationInfo = [
            1:(center:self.blueColorOption.center,location:CGPoint(x: self.blueColorOption.frame.minX, y: self.blueColorOption.frame.minY)),
            2:(center:self.redColorOption.center,location:CGPoint(x: self.redColorOption.frame.minX, y: self.redColorOption.frame.minY)),
            3:(center:self.orangeColorOption.center,location:CGPoint(x: self.orangeColorOption.frame.minX, y: self.orangeColorOption.frame.minY)),
            4:(center:self.whiteColorOption.center,location:CGPoint(x: self.whiteColorOption.frame.minX, y: self.whiteColorOption.frame.minY)),
            5:(center:self.greenColorOption.center,location:CGPoint(x: self.greenColorOption.frame.minX, y: self.greenColorOption.frame.minY)),
            6:(center:self.yellowColorOption.center,location:CGPoint(x: self.yellowColorOption.frame.minX, y: self.yellowColorOption.frame.minY))
         ]
         self.invalidateColorOptionsIfNeededAfter()
         self.handleBluredImageForLegendMode()
    }
    func getCenterForColorOptionAt(index:Int)->CGPoint?{
        var center:CGPoint? = nil
        let startX = self.colorsContainerView.frame.minX
        let startY = self.colorsContainerView.frame.minY
        center = CGPoint(x: startX+(55.0*CGFloat(index)-25.0), y: startY+30.0)
        return center
    }
    func setCenterToColorOptions(){
        for tag in 1...6{
            if let view = self.view.viewWithTag(tag),let center = getCenterForColorOptionAt(index:tag){
                view.center =  center
            }
        }
    }
    func configColorOptionsView(){
        self.colorsContainerView.roundBorder(by: 10.0)
        self.disableColorOptionsIfNeeded()
        self.blueColorOption.tag = 1
        self.redColorOption.tag = 2
        self.orangeColorOption.tag = 3
        self.whiteColorOption.tag = 4
        self.greenColorOption.tag = 5
        self.yellowColorOption.tag = 6
        
        self.blueColorOption.addInteraction(UIDragInteraction(delegate: self))
        self.blueColorOption.configWith(cornerRadius: 5.0, borderWidth: 0,borderColor: UIColor(red: 100/255, green: 10/255, blue: 1, alpha: 1))
        self.redColorOption.configWith(cornerRadius: 5.0, borderWidth: 0,borderColor: UIColor.gray)
        self.whiteColorOption.configWith(cornerRadius: 5.0, borderWidth: 0,borderColor: UIColor.gray)
        self.greenColorOption.configWith(cornerRadius: 5.0, borderWidth: 0,borderColor: UIColor.gray)
        self.yellowColorOption.configWith(cornerRadius: 5.0, borderWidth: 0,borderColor: UIColor.gray)
        self.orangeColorOption.configWith(cornerRadius: 5.0, borderWidth: 0,borderColor: UIColor.gray)
        self.blueColorOption.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(draggView(_:))))
        self.redColorOption.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(draggView(_:))))
        self.whiteColorOption.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(draggView(_:))))
        self.greenColorOption.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(draggView(_:))))
        self.orangeColorOption.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(draggView(_:))))
        self.yellowColorOption.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(draggView(_:))))
        self.blueColorOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleColorSelected(_:))))
        self.redColorOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleColorSelected(_:))))
        self.whiteColorOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleColorSelected(_:))))
        self.greenColorOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleColorSelected(_:))))
        self.orangeColorOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleColorSelected(_:))))
        self.yellowColorOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleColorSelected(_:))))
    }
    func createTemporalSubstituteImageFor(color:UIColor,center:CGPoint,location:CGPoint,width:CGFloat,height:CGFloat)->UIView?{
        guard let label = getNumberOfColorsMissingLabel(color:color, width: width/2.0,height: height/2.0) else{
            return nil
        }
        label.isHidden = false
        let substituteView:UIView = UIView(frame: CGRect(x: location.x, y: location.y, width: width, height: height))
        label.center = CGPoint(x: width/2.0, y: height/2.0)
        
        substituteView.addSubview(label)
        substituteView.backgroundColor = color
        substituteView.configWith(cornerRadius: 5.0, borderWidth: 4,borderColor: UIColor.gray)
        substituteView.tag = DRAGGED_TEMPORAL_IMAGE_TAG
        substituteView.bringSubviewToFront(label)
        substituteView.layoutSubviews()
        return substituteView
    }
    func printReverseMovesTOSetCubeToSolve(){
        let moves = Session.shared.level.moves.convertStringSeparateByCommasToArray()
        for i in 0..<moves.count{
            print( invert(move: moveIdentifiers[moves[i]]!))
        }
    }
    func getNumberOfColorsMissingLabel(color:UIColor,width:CGFloat,height:CGFloat)->UILabel?{
        guard let missingPeaces = self.missingPeacesByColor[color] else{
            return nil
        }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let font =  UIFont.systemFont(ofSize: 20, weight: .bold)
        label.font = font
        label.backgroundColor = color
        label.tintColor = UIColor.white
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.text = missingPeaces == 0 ?  "❌" : "\(missingPeaces)"
        return label
            
    }
    func removeTemporalImage(){
        if let view = self.view.viewWithTag(DRAGGED_TEMPORAL_IMAGE_TAG){
            view.removeFromSuperview()
        }
    }
    func getRightIdentifierFromImageTag(tag:Int)->Int?{
        guard let identifierIndex = self.Bokin3x3x3.identifierAsociatedItem[tag] else{
            return nil
        }
        if let faceTouched = self.Bokin3x3x3.getUniqueIdentifierFace(identifier: tag){
            for vector in  self.Bokin3x3x3.cubeItems[identifierIndex].vectors{
                if let stickerFace = vector.vectorDirection{
                    if faceTouched == stickerFace{
                        return vector.uniqueIdentifier!
                    }
                }
            }
        }
        return nil
    }
    @objc func draggView(_ panGesture:UIPanGestureRecognizer){
        if let viewDrag = panGesture.view{
            self.view.bringSubviewToFront(viewDrag)
            let translation = panGesture.translation(in: self.view)
            viewDrag.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
            panGesture.setTranslation(CGPoint.zero, in: self.view)
            let scnView = self.view!
            if (panGesture.state == .began){
                self.removeBorderForAllColorOption()
                self.draggedImageIndex = panGesture.view!.tag
                self.selectedColor = self.colorOptions[panGesture.view!.tag]!
                let selectedColorLocationInfo = self.colorOptionsOriginalLocationInfo[self.draggedImageIndex!]!
                if let view = self.createTemporalSubstituteImageFor(color: self.selectedColor!, center: selectedColorLocationInfo.center, location: CGPoint(x: selectedColorLocationInfo.location.x, y: selectedColorLocationInfo.location.y), width: panGesture.view!.frame.width, height: panGesture.view!.frame.height){
                    self.view.addSubview(view)
                }
            }
            if (panGesture.state == .ended){
                self.removeTemporalImage()
                let location = panGesture.location(in: scnView)
                let _ = scnView.hitTest(location, with: nil)
                if let imageTag = self.getStickerImages(dropedImageCenter:viewDrag.center),let rightIdentifier = getRightIdentifierFromImageTag(tag:imageTag),didUserDropedColorOverAMissingPeace(identifier:rightIdentifier){
                    if let imageView = self.view.viewWithTag(imageTag){
                        self.handleTryToPaintSticker(stickerImageView:imageView)
                    }
                }else{
                    self.handleWrongTry(withIncrement:true)
                }
                if self.draggedImageIndex != nil,let draggedView = self.view.viewWithTag(self.draggedImageIndex!){
                    draggedView.center = self.colorOptionsOriginalLocationInfo[self.draggedImageIndex!]!.center
                }
            }
        }
    }
    func wasImageDroppedInAMissingCubeItem(stickerIdentifier:Int)->Bool{
        var indexes:Array<Int> = Array<Int>.init()
        let _ = self.missingStickersTags.map({ identifier in
            if let identifierIndex = self.Bokin3x3x3.identifierAsociatedItem[identifier],let realIndex = self.Bokin3x3x3.itemsRealIndex[identifierIndex]{
                indexes.append(realIndex)
            }
        })
        let stickerIdentifierIndex = self.Bokin3x3x3.identifierAsociatedItem[stickerIdentifier]!
        if indexes.contains(stickerIdentifierIndex){
            return true
        }
        return false
    }
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    func getStickerImages(dropedImageCenter:CGPoint)->Int?{
        let imageTagBoundries = self.Bokin3x3x3.getUniqueidentifiersRange()
        var shortestDistance:CGFloat = CGFloat(imageTagBoundries.end)
        var tag:Int? = nil
        for view in self.view.subviews{
            if let sticker = view as? UIImageView{
                if (imageTagBoundries.start <= sticker.tag && imageTagBoundries.end >= sticker.tag){
                    let distance = CGPointDistance(from: dropedImageCenter, to: sticker.center)
                    if shortestDistance > distance{
                        shortestDistance = distance
                        tag = sticker.tag
                    }
                }
            }
        }
        if shortestDistance > 30{
            tag = nil
        }
        return tag
    }
    func putSolidColorToIndex(){
        var indexes:Array<Int> = [Int](0..<self.Bokin3x3x3.baseWidth*Bokin3x3x3.baseHeight*self.Bokin3x3x3.cubeHeight)
        let fakeItems = self.Bokin3x3x3.getFakeItemsPositions()
        let _ = fakeItems.map({
            if let location = indexes.index(of: $0){
                indexes.remove(at: location)
            }
        })
        for i in indexes{
            for n in self.Bokin3x3x3.cubeItemsUniqueIdentifier[i]!{
                self.uniqueIdentifiersUnfound.append(n)
            }
        }
        self.addTapGestureToStickersWithTags(tags: uniqueIdentifiersUnfound)
    }
    func setStickersToUniformColorBasedOnNonFinishedLevel(){
        if let missingStickers = Session.shared.level.missingPeacesIdentifiers.convertToJsonObject(){
            for itemIndex in 0..<self.Bokin3x3x3.cubeItems.count{
                if let x = missingStickers["\(itemIndex)"]{
                    for vector in self.Bokin3x3x3.cubeItems[itemIndex].vectors{
                        if vector.color.rawValue == x{
                            vector.setUniforColor(color:CubeColor.Gray)
                        }
                    }
                }
            }
        }
    }
    func setStickersToUniformColor(count:Int){
        if (self.isRecreantingANonFinishedLevel){
            self.setStickersToUniformColorBasedOnNonFinishedLevel()
            return
        }
        var stickers:(colors:[CubeColor:Int],vectors:Array<Vector>,data:[String:CubeColor]) = (colors:[:],vectors:Array<Vector>.init(),data:[:])
        //let sessionMissingStickers:Array<Int> = self.getReallMissingPeacesPeaces().convertStringSeparateByCommasToArray()
        let sessionMissingStickers:[String:String] = self.getReallMissingPeacesDataAsDict()
        if self.isLoadingView && sessionMissingStickers.count > 0{
            stickers = self.Bokin3x3x3.getCubeColorRelationGiven(data:sessionMissingStickers)
            //stickers = self.Bokin3x3x3.getCubeColorRelationGiven(identifiers:sessionMissingStickers)
        }else{
            let count = !self.isCreatingANewLevel && (Session.shared.level.foundPeacesIdentifiers.convertToJsonObject() != nil && Session.shared.level.foundPeacesIdentifiers.convertToJsonObject()!.count > 0) ? self.getReallMissingPeacesDataAsDict().count : Session.shared.level.missingPeaces!
            stickers = self.Bokin3x3x3.setStickersToUniformColorForDeterministicColorFindingFace(count: count)
        }
        var missingPeacesBeforeParse:[String:String] = [:]
        for d in stickers.data.enumerated(){
            missingPeacesBeforeParse[d.element.key] = d.element.value.rawValue
        }
        for n in stickers.colors.enumerated(){
            self.missingPeacesByColor[UICubeColors[n.element.key]!] = stickers.colors[n.element.key]
        }
        let _ = stickers.vectors.map({ (vector:Vector) in
            self.missingStickersTags.append(vector.uniqueIdentifier!)
        })
        if self.isCreatingANewLevel || FIRST_TIME_APP_SHOWS{
            self.setSessionMissingPeaces(data:missingPeacesBeforeParse.dict2json().description)
        }
        self.updateLevelLabel(level:self.getLevelNumber())
    }
    func getLevelNumber()->Int{
        let missing = getReallMissingPeacesDataAsDict().count
        let found = Session.shared.level.foundPeacesIdentifiers.convertToJsonObject()?.count
        let levelNumber = missing + (found != nil ? found! : 0)
        return levelNumber <= LEVELS_PER_DIFFICULTY ? levelNumber : 1
    }
    func getVectorsASIdentifiersArray(vectors:Array<Vector>)->Array<Int>{
        var identifiers:Array<Int> = Array<Int>.init()
        for vector in vectors{
            identifiers.append(vector.uniqueIdentifier!)
        }
        return identifiers
    }
    
    func setSessionMissingPeaces(identifiers:Array<Int>){
        Session.shared.level.missingPeacesIdentifiers = generateMIssingStickerStringWith(identifiers:identifiers)
    }
    func setSessionMissingPeaces(data:String){
        Session.shared.level.missingPeacesIdentifiers = data
        self.updateMissingPeacesForLevel()
    }
    func generateMIssingStickerStringWith(identifiers:Array<Int>)->String{
        var result:String = ""
        for identifier in identifiers{
            result = "\(result),\(identifier)"
        }
        return result
    }
    func updateLevelLabel(level:Int){
        self.levelLbl.text = "\(NSLocalizedString("Level", comment: "")) \(level)"
    }
    func addTapGestureToStickersWithTags(tags:Array<Int>){
        for tag in tags{
            if  let imageView = self.view.viewWithTag(tag) as? UIImageView{
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleStickerTap(_:))))
            }
        }
    }
    func getNumberOfAllowedPaintingTrys(level:GameDifficultyLevel)->Int{
        let missingPeaces = Session.shared.level.missingPeacesIdentifiers.convertToJsonObject()?.count != nil ? Session.shared.level.missingPeacesIdentifiers.convertToJsonObject()!.count : 0
        let foundPeaces = Session.shared.level.foundPeacesIdentifiers.convertToJsonObject()?.count != nil ? Session.shared.level.foundPeacesIdentifiers.convertToJsonObject()!.count : 0
        switch level {
            case .brave:
                return (missingPeaces+foundPeaces)
        case .alpha_male:
                return (missingPeaces+foundPeaces)
            default:
                return 0
        }
        
    }
    func handleTrysLabelVisibility(level:GameDifficultyLevel){
        self.trysLbl.isHidden = true
        if level == GameDifficultyLevel.legend{
             self.trysLbl.isHidden = true
        }
        
    }
    func updateScoreLabel(){
        self.scoreLabel.text = "\(NSLocalizedString("Score", comment: "")) : \(self.score)/\(self.getLevelNumber())"
        self.trysLbl.text = "\(NSLocalizedString("Trys", comment: "")): \(self.wrongColorSelected)/\(self.getNumberOfAllowedPaintingTrys(level:Config.shared.difficulty))"
    }
    @objc func handleStickerTap(_ gesture:UITapGestureRecognizer){
        self.handleTryToPaintSticker(stickerImageView:gesture.view)
    }
    @objc func handleColorSelected(_ gesture:UITapGestureRecognizer){
        self.removeBorderForAllColorOption()
        let view:UIView = gesture.view!
        view.setBorder(by: 4)
        view.setBorderColor(to: UIColor.gray)
        self.selectedColor = self.colorOptions[view.tag]!
    }
    func getSelectedIndicatorLabel(color:UIColor,width:CGFloat,height:CGFloat)->UILabel?{
        self.removeViewWith(tag: 103)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let font =  UIFont.systemFont(ofSize: 20, weight: .bold)
        label.font = font
        label.tintColor = color
        label.textAlignment = .center
        label.tag = 103
        label.text =  "✅"
        return label
        
    }
    func showPerformingMovesHistoricalActivityIndicator(){
        self.replicatingStateActivityIndicator.startAnimating()
    }
    func hiddePerformingMovesHistoricalActivityIndicator(){
        self.replicatingStateActivityIndicator.isHidden = true
        self.replicatingStateActivityIndicator.stopAnimating()
    }
    func removeBorderForAllColorOption(){
        for data in self.colorOptionsTagsByColor.enumerated(){
            if let view = self.view.viewWithTag(data.element.value){
                view.setBorder(by: 0)
            }
        }
    }
    func changeImageTransparencyForAllColorOption(){
        for data in self.colorOptionsTagsByColor.enumerated(){
            if let view = self.view.viewWithTag(data.element.value){
                view.setBorder(by: 0)
            }
        }
    }
    func updateFoundPeacesForLevel(identifier:Int){
        Session.shared.level.foundPeacesIdentifiers = Session.shared.level.foundPeacesIdentifiers != nil ? "\(Session.shared.level.foundPeacesIdentifiers!),\(identifier)" : "\(identifier)"
       self.updateFoundPeaces()
    }
    func updateFoundPeacesForLevel(index:Int,color:CubeColor){
        if var actualMissingPeaces:[String:String] = Session.shared.level.foundPeacesIdentifiers.convertToJsonObject(){
            actualMissingPeaces["\(index)"] = color.rawValue
            Session.shared.level.foundPeacesIdentifiers = actualMissingPeaces.dict2json()
        }else{
            Session.shared.level.foundPeacesIdentifiers = ["\(index)":color.rawValue].dict2json()
        }
        self.updateMissingPeacesForLevel()
        self.updateMissingPeacesCount()
        self.updateFoundPeaces()
        self.updateScoreData()
    }
    func updateFoundPeaces(){
        Session.shared.updateSessionRegisterWith(searchTerms: (key:"identifier",value:Session.shared.level.identifier), updateData: (key:"already_found_peaces",value:Session.shared.level.foundPeacesIdentifiers))
    }
    func getReallMissingPeacesPeaces()->String{
        let alreadyFoundPeaces:Array<Int> = Session.shared.level.foundPeacesIdentifiers.convertStringSeparateByCommasToArray()
        var missingPeaces = Session.shared.level.missingPeacesIdentifiers.convertStringSeparateByCommasToArray()
        for identifier in alreadyFoundPeaces{
            if let indexOfIdentifier = missingPeaces.index(of: identifier){
                let _ = missingPeaces.remove(at: indexOfIdentifier)
            }
        }
        return self.generateMIssingStickerStringWith(identifiers: missingPeaces)
    }
    func getReallMissingPeacesDataAsDict()->[String:String]{
        guard var missingPeaces:[String:String] = Session.shared.level.missingPeacesIdentifiers.convertToJsonObject() else{
            return [:]
        }
        if let alreadyFoundPeaces:[String:String] = Session.shared.level.foundPeacesIdentifiers.convertToJsonObject() {
            for data in alreadyFoundPeaces.enumerated(){
                missingPeaces.removeValue(forKey: "\(data.element.key)")
            }
            Session.shared.level.missingPeacesIdentifiers = missingPeaces.dict2json()
        }
        return missingPeaces
    }
    func removeFoundedIdentifierFromMissingPeaces(identifier:Int){
        var moves:Array<Int> = Session.shared.level.missingPeacesIdentifiers.convertStringSeparateByCommasToArray()
        guard moves.count > 0 else{
            return
        }
        if let indexOfIdentifier = moves.index(of: identifier){
            let _ = moves.remove(at: indexOfIdentifier)
            Session.shared.level.missingPeacesIdentifiers = self.generateMIssingStickerStringWith(identifiers: moves)
            self.updateMissingPeacesForLevel()
        }
    }
    func updateMissingPeacesCount(){
        if Session.shared.level.missingPeaces > 0{
            Session.shared.level.missingPeaces-=1
        }
        Session.shared.updateSessionRegisterWith(searchTerms: (key:"identifier",value:Session.shared.level.identifier), updateData: (key:"missing_peaces",value:Session.shared.level.missingPeaces))
    }
    func doesTheUserStillHasOptions()->Bool{
        let foundPeaces = Session.shared.level.foundPeacesIdentifiers.convertToJsonObject() != nil ? Session.shared.level.foundPeacesIdentifiers.convertToJsonObject()!.count : 0
        let levelAllowedTrys = self.getNumberOfAllowedPaintingTrys(level:Config.shared.difficulty)
        if ((Session.shared.level.failedTrys >= levelAllowedTrys) || (foundPeaces >= levelAllowedTrys)){
            return false
        }
        return true
    }
    func didUserDropedColorOverAMissingPeace(identifier:Int?)->Bool{
        let missingPeacesDict = Session.shared.level.missingPeacesIdentifiers.convertToJsonObject()
        if identifier != nil,let indexOfStickerWhereColorIsDroppeIn = self.Bokin3x3x3.identifierAsociatedItem[identifier!]{
            if ((missingPeacesDict != nil && missingPeacesDict!["\(indexOfStickerWhereColorIsDroppeIn)"] != nil)){
                return true
            }
        }
        return false
    }
    func handleTryToPaintSticker(stickerImageView:UIView?){
        if (!self.allowPaintTry || !self.doesTheUserStillHasOptions()){
            return
        }
        self.countToAvoidMultiplePaintTrys()
        guard let tapedView = stickerImageView,let r = self.Bokin3x3x3.identifierAsociatedItem[tapedView.tag] else{
            self.updateScoreLabel()
            return
        }
        var rightIdentifier:Int? = nil
        var stickerColor:CubeColor? = nil
        if let faceTouched = self.Bokin3x3x3.getUniqueIdentifierFace(identifier: tapedView.tag){
            for vector in  self.Bokin3x3x3.cubeItems[r].vectors{
                if let stickerFace = vector.vectorDirection{
                    if faceTouched == stickerFace{
                        rightIdentifier = vector.uniqueIdentifier!
                        stickerColor = vector.color
                        break
                    }
                }
            }
        }
        if (!didUserDropedColorOverAMissingPeace(identifier:rightIdentifier)){
            return
        }
        self.invalidateColorOptionsIfNeededAfter()
        guard stickerColor != nil, let selectedColor = self.selectedColor else{
            self.updateScoreLabel()
            return
        }
        if UICubeColors[stickerColor!] == selectedColor && self.isAMissingImage(color:stickerColor!){
            self.score+=1
            self.updateScoreData()
            self.updateScoreLabel()
            for i in 0..<self.Bokin3x3x3.cubeItems[r].vectors.count{
                if self.Bokin3x3x3.cubeItems[r].vectors[i].uniqueIdentifier == rightIdentifier{
                    self.Bokin3x3x3.cubeItems[r].vectors[i].useUniformColor = nil
                }
            }
            if  let imageView = self.view.viewWithTag(tapedView.tag) as? UIImageView{
                let origImage = imageView.image
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                imageView.image =  tintedImage
                imageView.tintColor = selectedColor
                self.reduceMissingColorBy(color:selectedColor,value:1)
                self.updateFoundPeacesForLevel(index:self.Bokin3x3x3.identifierAsociatedItem[rightIdentifier!]!,color:stickerColor!)
                self.updateScoreData()
            }
        }else{
            self.handleWrongTry(withIncrement:true)
        }
    }
    func countToAvoidMultiplePaintTrys(){
        self.startCountingTimeForMultipleDropTrys()
    }
    func startCountingTimeForMultipleDropTrys(){
        self.allowPaintTry = false
        self.allowedTrysTimer.start(timeInterval: 1, target: self, selector: #selector(self.countTimeAfterTry), userInfo: nil, repeats: true)
    }
    @objc func countTimeAfterTry(){
        if (self.secondsCountAfterTry > 1)
        {
            self.allowPaintTry = true
            self.secondsCountAfterTry = 0
            self.allowedTrysTimer.stop()
        }else{
            self.secondsCountAfterTry += 1
            self.allowPaintTry = false
        }
    }
    public func getDifficultyLevelPaintAllowedTrys()->Int{
        switch Config.shared.difficulty {
            case .brave:
                return 31415
            case .alpha_male:
                return Session.shared.level.missingPeaces
            default:
                return 0
        }
    }
    func invalidateColorOptionsIfNeededAfter(){
        self.removeBluredImage()
        self.invalidateColorOptionsIfAlphaMale()
        self.invalidateColorOptionsIfForBrave()
        
    }
    func invalidateColorOptionsIfAlphaMale(){
        if Config.shared.difficulty == .alpha_male{
            if self.wrongColorSelected >= self.getNumberOfAllowedPaintingTrys(level:Config.shared.difficulty){
                self.addBluredImageOverColorOptions()
            }
        }
    }
    func invalidateColorOptionsIfForBrave(){
        if Config.shared.difficulty == .brave{
            if self.wrongColorSelected >= (self.getNumberOfAllowedPaintingTrys(level:Config.shared.difficulty)){
                self.addBluredImageOverColorOptions()
            }
        }
    }
    func handleWrongTry(withIncrement:Bool){
        if withIncrement{
            self.wrongColorSelected+=1
            Session.shared.level.failedTrys = self.wrongColorSelected
            self.invalidateColorOptionsIfNeededAfter()
            self.updateScoreData()
        }
        self.updateScoreLabel()
    }
    func isAMissingImage(color:CubeColor)->Bool{
        if let missingPeaces = Session.shared.level.missingPeacesIdentifiers.convertToJsonObject(){
            for missingcolor in missingPeaces.enumerated(){
                if missingcolor.element.value == color.rawValue{
                    return true
                }
            }
        }
        return false
    }
    func proccessAllImageToFindMissingColorsFinished(){
        for color in self.missingPeacesByColor.enumerated(){
            if self.missingPeacesByColor[color.element.key] == 0 && self.isAMissing(color:color.element.key){
                if let view = self.view.viewWithTag(colorOptionsTagsByColor[color.element.key]!){
                    proccessImageMissingColorsFinished(imageView:view)
                }
            }
        }
    }
    func isAMissing(color:UIColor)->Bool{
        if let foundPeaces = Session.shared.level.foundPeacesIdentifiers.convertToJsonObject(){
            for cubecolor in UICubeColors.enumerated(){
                if cubecolor.element.value == color{
                    for foundPeace in foundPeaces.enumerated(){
                        if foundPeace.element.value == cubecolor.element.key.rawValue{
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    func reduceMissingColorBy(color:UIColor,value:Int){
        if self.missingPeacesByColor[color] != nil{
            let val = self.missingPeacesByColor[color]! - value
            self.missingPeacesByColor[color] = val
            self.requireNextLevelIfNeeded()
            if val == 0{
                if let view = self.view.viewWithTag(self.colorOptionsTagsByColor[color]!){
                    self.proccessImageMissingColorsFinished(imageView:view)
                }
            }
        }else{
            self.missingPeacesByColor[color] = 0
        }
    }
    func requireNextLevelIfNeeded(){
        if (self.areCurrentLevelConditionsSatisfied(level:Config.shared.difficulty)){
            self.disableAllColorOtions()
            self.tellUserHeJustFininshedSolvingTheCube()
        }
    }
    func areCurrentLevelConditionsSatisfied(level:GameDifficultyLevel)->Bool{
        self.completePercent = self.Bokin3x3x3.getCompletePercent()
        switch level{
            case .brave:
                return self.isBraveLevelFinished()
            case .alpha_male:
                return self.isAlphaMaleLevelFinished()
            default:
                return self.isLegendLevelFinished()
            }
        }
    func isCubeSolvedWithNotMoreTrys()->Bool{
        if ((self.shouldCountSolvePercentEvaluationForSolveCompletion && self.completePercent == 100.0) && !self.doesTheUserStillHasOptions()){
            return true
        }
        return false
    }
    func isBraveLevelFinished()->Bool{
        if (self.isCubeSolvedWithNotMoreTrys() || ((self.shouldCountSolvePercentEvaluationForSolveCompletion && self.completePercent == 100.0) && self.didUserFinishedPaintingTheCube())){
            return true
        }
        return false
    }
    func isAlphaMaleLevelFinished()->Bool{
        if (isCubeSolvedWithNotMoreTrys() || (self.shouldCountSolvePercentEvaluationForSolveCompletion && self.completePercent == 100.0)){
            return true
        }
        return false
    }
    func isLegendLevelFinished()->Bool{
        if (self.shouldCountSolvePercentEvaluationForSolveCompletion && self.completePercent == 100.0){
            return true
        }
        return false
    }
    func didUserFinishedPaintingTheCube()->Bool{
        for color in self.missingPeacesByColor.enumerated(){
            if self.missingPeacesByColor[color.element.key]! > 0{
                return false
            }
        }
        return true
    }
    func getMessageForFinishedLevel()->String{
        return "You finished the level \(self.getLevelNumber()) of \(Config.shared.difficulty.toString())"
    }
    func tellUserHeJustFininshedSolvingTheCube(){
        self.levelCompletedLabel.isHidden = false
        if (self.isLoadingAFinishedLevel){
            return
        }
        self.updatePassedLevelData()
        self.playAudioEffect(fileName: "finishedLevel", format: "mp3")
        let _ = SolvedData.shared.connector.updateLevelBy(levelname: Config.shared.difficulty.toString(), missingpeaces: self.getLevelNumber())
        let alert = UIAlertController(title: NSLocalizedString("Congratulations", comment: "") , message: NSLocalizedString(self.getMessageForFinishedLevel(), comment: "")  , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Go to level \(self.getLevelNumber()+1)", comment: "") , style: UIAlertAction.Style.default, handler: ({ alert in
            self.solvedCountState = .outdate
            self.handleUserIsGonnaTryNextLevel()
        })))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "")  , style: UIAlertAction.Style.default, handler:({ alert in
             self.solvedCountState = .outdate
             self.handleUserClickOkAfterFinishedLevel()
        })))
        alert.view.backgroundColor = UIColor.black
        self.present(alert, animated: true, completion: nil)
    }
    func handleUserClickOkAfterFinishedLevel(){
        self.enableAllColorOtions()
        Session.shared.level.time  = 0
        self.solveTimer.stop()
        self.showNextButton()
        self.disableAllColorOtions()
    }
    func showNextButton(){
        self.nextLevel.isHidden = false
        self.getRightTextTuNextButtonAfterFInishinAllLevelForDifficultyLevel()
    }
    func getRightTextTuNextButtonAfterFInishinAllLevelForDifficultyLevel(){
        if ((self.getLevelNumber()) == LEVELS_PER_DIFFICULTY){
            self.nextLevel.titleLabel?.text = "Restart"
        }
    }
    func updatePassedLevelData(){
        Session.shared.updateSessionRegisterWith(searchTerms: (key:"identifier",value:Session.shared.level.identifier), updateData: (key:"state",value: levelState.complete.rawValue ))
        self.updateTimeData()
        Session.shared.updateSessionRegisterWith(searchTerms: (key:"identifier",value:Session.shared.level.identifier), updateData: (key:"date",value:Date()))
        self.updateScoreData()
    }
    func updateScoreData(){
        Session.shared.updateSessionRegisterWith(searchTerms: (key:"identifier",value:Session.shared.level.identifier), updateData: (key:"score",value:self.score))
        Session.shared.updateSessionRegisterWith(searchTerms: (key:"identifier",value:Session.shared.level.identifier), updateData: (key:"failed_trys",value:Session.shared.level.failedTrys))
    }
    func updateMissingPeacesForLevel(){
        guard var missingPeaces:[String:String] = Session.shared.level.missingPeacesIdentifiers.convertToJsonObject() else{
            return
        }
        if let alreadyFoundPeaces:[String:String] = Session.shared.level.foundPeacesIdentifiers.convertToJsonObject() {
            for data in alreadyFoundPeaces.enumerated(){
                missingPeaces.removeValue(forKey: "\(data.element.key)")
            }
            Session.shared.level.missingPeacesIdentifiers = missingPeaces.dict2json()
        }
        Session.shared.updateSessionRegisterWith(searchTerms: (key:"identifier",value:Session.shared.level.identifier), updateData: (key:"misssing_peaces_identifiers",value:Session.shared.level.missingPeacesIdentifiers))
    }
    func resetCubeToOriginalState(){
        self.handleViewDidLoad()
    }
    func getMIssingPeacesForNextLevel(incrementedBy:Int)->Int{
        var nextLevel:Int = self.getLevelNumber() + incrementedBy
        if self.actualLevelCopy != Config.shared.difficulty{
            nextLevel = Level.getLastLevelSolvedFor(dificulty_level: Config.shared.difficulty.toString())
        }
        return nextLevel <= LEVELS_PER_DIFFICULTY ? nextLevel : 1
    }
    func handleUserIsGonnaReestartLevelBasedOn(level:Level){
        self.isRecratingCubeState = true
        self.solvedCountState = .outdate
        self.isRecreantingANonFinishedLevel = true
        self.isCreatingANewLevel = false
        Session.shared.level = level
        self.tryToLoadDataFromServer()
        self.resetCubeToOriginalState()
        self.performedRandomScramble = false
        self.performMovesStoredInSession(moves:Session.shared.level.moves.convertStringSeparateByCommasToArray())
        self.solveTimer.stop()
        self.updateSessionInfo()
        self.enableAllColorOtions()
        self.disableColorOptionsIfNeeded()
        self.updateMissingPeacesForLevel()
        self.removeViewForLoading()
        self.updateScoreLabel()
        self.isRecreantingANonFinishedLevel = false
        self.isRecratingCubeState = false
    }
    func handleUserIsGonnaTryNextLevel(incrementedBy:Int = 1){
        self.removeBluredImageIfNoLegendDifficulty()
        self.time = 0
        self.setTimeLabel(to: "00 : 00")
        self.tryToLoadDataFromServer()
        self.isCreatingANewLevel = true
        self.levelCompletedLabel.isHidden = true
        self.movesCount = 0
        //Session.shared.level.foundPeacesIdentifiers = ""
        Session.shared.level.missingPeaces = getMIssingPeacesForNextLevel(incrementedBy:incrementedBy)
        self.movesHistorical = []
        Session.shared.level.identifier = ""
        Session.shared.level.time  = 0
        Session.shared.level.moves = ""
        Session.shared.level.foundPeacesIdentifiers = ""
        self.resetCubeToOriginalState()
        self.solveTimer.stop()
        self.scrabler.moves4Scrable = 20
        self.doScrable()
        self.updateSessionInfo()
        self.enableAllColorOtions()
        self.createNewLevel()
        self.updateMissingPeacesForLevel()
        self.removeViewForLoading()
        self.isCreatingANewLevel = false
        self.handleNextLevelButtonVisibility()
        self.hanldeTimeToNextTriesReduceViibility()
    }
    func createNewLevel(){
        let movesString = self.generateStringFromMoveHistorical()
        Session.shared.level.foundPeacesIdentifiers = ""
        Session.shared.level.failedTrys = 0
        Session.shared.level.score = 0
        self.score = 0
        self.wrongColorSelected = 0
        self.updateScoreLabel()
        let level:Level = Level(moves: movesString, time: 0.0, date: Date(), score: 0, state: levelState.waiting, failedTrys: 0, missingPeaces: Session.shared.level.missingPeaces,missingPeacesIdentifiers:Session.shared.level.missingPeacesIdentifiers,foundPeacesIdentifiers:Session.shared.level.foundPeacesIdentifiers,dificulty_level:Config.shared.difficulty.toString(),level_number:Session.shared.level.missingPeaces,sent_to_server:false)
        level.saveIntoCoreData()
        if let level = self.isThereANonFinishedLevelOf(dificulty:Config.shared.difficulty){
            Session.shared.level = level
        }
        
    }
    func disableAllColorOtions(){
        for color in self.missingPeacesByColor.enumerated(){
            if let view = self.view.viewWithTag(colorOptionsTagsByColor[color.element.key]!){
                self.proccessImageMissingColorsFinished(imageView:view)
            }
        }
    }
    func enableAllColorOtions(){
        for color in self.missingPeacesByColor.enumerated(){
            if let view = self.view.viewWithTag(colorOptionsTagsByColor[color.element.key]!){
                self.proccessImageMissingColorsHasColors(imageView:view)
            }
        }
    }
    func proccessImageMissingColorsHasColors(imageView:UIView){
        imageView.backgroundColor = colorOptions[imageView.tag]!
        imageView.isUserInteractionEnabled = true
    }
    func proccessImageMissingColorsFinished(imageView:UIView){
        imageView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 140/255, alpha: 0.4)
        imageView.isUserInteractionEnabled = false
    }
    
    @objc func willResignActive(_ notification: Notification) {
        self.solveTimer.stop()
        Session.shared.level.updateData()
    }
    @objc func willBecomeActive(_ notification: Notification) {
        Session.shared.level.updateData()
        self.timeLbl.text = "\(String(format: "%02i", self.convertTimeInSecondsToMinutes(time:time))) : \(String(format: "%02i", Int(self.getSecondsWithTreshHold(time:time,treshHold:60.0))))"
        if !self.areCurrentLevelConditionsSatisfied(level: Config.shared.difficulty){
            self.startTimer()
        }
    }
    
    func startCountingToReplicate(){
        self.setSavedMovesHistoricalOfTheSession()
        self.updateScoreData()
        if self.askRate{
            Util.shared.askUserToRateTheApp(movesCount:Level.getMovesHistoricalCOunt())
        }
    }
    
    func addViewForLoading(){
        let view:UIView = UIView(frame: CGRect(x: 100, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.center = self.view.center
        view.backgroundColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 0.35)
        view.tag = 102
        self.view.addSubview(view)
    }
    func removeViewForLoading(){
        if let viewToRemove = self.view.viewWithTag(102){
            viewToRemove.removeFromSuperview()
        }
    }
    func removeViewWith(tag:Int){
        if let viewToRemove = self.view.viewWithTag(tag){
            viewToRemove.removeFromSuperview()
        }
    }
    func setSavedMovesHistoricalOfTheSession(){
        self.isRecratingCubeState = true
        self.shouldCountMove = false
        self.showPerformingMovesHistoricalActivityIndicator()
        let moves:Array<Int> = Session.shared.level.getMovesAsArray()
        self.movesHistorical = moves
        self.performMovesStoredInSession(moves: moves)
        self.hiddePerformingMovesHistoricalActivityIndicator()
        self.isRecratingCubeState = false
        self.shouldCountMove = true
        self.view.isUserInteractionEnabled = true
        self.removeViewForLoading()
    }
   
    func performMovesStoredInSession(moves:Array<Int>){
        guard !performedRandomScramble else{return}
        for move in moves{
            self.performMoveUsingFunctionName(identifier:move)
        }
    }
  
    func performMoveUsingFunctionName(identifier:Int){
        self.shouldAddMove = false
        self.perform(NSSelectorFromString(moveIdentifiers[identifier]!), with: self)
        self.shouldAddMove = true
    }
    
    func convertTimeInSecondsToMinutes(time:Double)->Int{
        return Int(floor(time/60.0))
    }
    func getSecondsWithTreshHold(time:Double,treshHold:Double)->Int{
        return Int(time - treshHold*(floor(time/treshHold)))
    }
    func startTimer(){
        self.startTime = Date().timeIntervalSinceReferenceDate
        if Session.shared.level.time > 0{
            self.startTime = self.startTime - Session.shared.level.time
        }
        self.solveTimer.start(timeInterval: 1, target: self, selector: #selector(self.setTime(gesturesTap:)), userInfo: nil, repeats: true)
       
    }
    func tryToLoadDataFromServer(){
        self.loadDataFromServer()
        self.timeShouldTryToLoadSolvedData  = 0
        self.timesSolvedLbl.font = UIFont(name: self.timesSolvedLbl.font.fontName, size: 22)
        self.solvedLevelsTimer.start(timeInterval: 0.1, target: self, selector: #selector(self.setSolvedLevelCount), userInfo: nil, repeats: true)
    }
    func isAMinute(second:Double)->Int?{
        return Int(second) % 60 == 0 ? (Int(second) / 60)  : nil
    }
    func reduceOptionsIfNeeded(second:Double){
        self.lblCOuntDonwToNextTryReduce.text =  "\(String(format: "%02i", 60-Int(self.getSecondsWithTreshHold(time:second,treshHold:60.0))))"
        if Config.shared.difficulty == .alpha_male && self.wrongColorSelected < self.getNumberOfAllowedPaintingTrys(level: GameDifficultyLevel.alpha_male), let _ = self.isAMinute(second:second){
            self.wrongColorSelected+=1
            Session.shared.level.failedTrys+=1
            self.updateScoreData()
            self.updateScoreLabel()
            if self.wrongColorSelected == self.getNumberOfAllowedPaintingTrys(level: GameDifficultyLevel.alpha_male){
                self.addBluredImageOverColorOptions()
                self.lblCOuntDonwToNextTryReduce.isHidden = true
            }
            
        }
    }
    @objc func setSolvedLevelCount(){
        if self.solvedCountState == .outdate, let val = SolvedData.shared.data[Config.shared.difficulty.toString()],let solvedCount = val["\(self.getLevelNumber())"]{
            self.timesSolvedLbl.text = solvedCount == 0 ? "\(NSLocalizedString("Never solved", comment: ""))" :  "\(solvedCount) \(NSLocalizedString("time\(solvedCount == 1 ? "" : "s") solved", comment: ""))"
            solvedCountState = .updated
            self.stopTryingToLoadData()
            self.moreBtn.isHidden = false
        }
        if (self.solvedCountState == .outdate && Int(floor(self.timeShouldTryToLoadSolvedData)) != Int(floor(self.timeShouldTryToLoadSolvedData-0.1))){
            var clock = ""
            (clock,clockTime) =  clockTime == 12 ? ("🕒",3) : clockTime == 3 ?  ("🕕",6) : clockTime == 6 ? ("🕘",9) : ("🕛",12)
            self.timesSolvedLbl.text = "\(clock) \(NSLocalizedString("Connecting", comment: ""))..."
        }
        if self.timeShouldTryToLoadSolvedData > 10.0{
            self.timesSolvedLbl.text = "\(NSLocalizedString("couldn't load data", comment: ""))"
            self.timesSolvedLbl.font = UIFont(name: self.timesSolvedLbl.font.fontName, size: 15)
            self.moreBtn.isHidden = true
            self.stopTryingToLoadData()
        }
        self.timeShouldTryToLoadSolvedData += 0.1
        
    }
    func stopTryingToLoadData(){
        self.solvedLevelsTimer.stop()
        self.timeShouldTryToLoadSolvedData  = 0
    }
    func setTimeLabel(to:String){
        self.timeLbl.text = to
    }
    @objc func setTime(gesturesTap:UITapGestureRecognizer){
        self.time = Date().timeIntervalSinceReferenceDate - self.startTime
        Session.shared.level.time = self.time
        self.timeLbl.text =  "\(String(format: "%02i", self.convertTimeInSecondsToMinutes(time:time))) : \(String(format: "%02i", Int(self.getSecondsWithTreshHold(time:time,treshHold:60.0))))"
        self.reduceOptionsIfNeeded(second: self.time)
         self.updateTimeData()
    }
    func isThereANonFinishedLevelOf(dificulty:GameDifficultyLevel)->Level?{
        if let level = Level.lastLevelUserDidNotFinish(dificulty_level: dificulty.toString()){
           return level
        }
        return nil
    }
    func createNewLevelIfUserChangeIt(){
        if  self.actualLevelCopy != Config.shared.difficulty{
            if let level = self.isThereANonFinishedLevelOf(dificulty:Config.shared.difficulty){
                 self.handleUserIsGonnaReestartLevelBasedOn(level: level)
            }else{
                self.handleUserIsGonnaTryNextLevel(incrementedBy: 0)
            }
        }else{
            if let level = self.isThereANonFinishedLevelOf(dificulty:Config.shared.difficulty){
                 Session.shared.level = level
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.removeBluredImage()
        self.lblCOuntDonwToNextTryReduce.isHidden = true
        self.solvedCountState = .outdate
        self.createNewLevelIfUserChangeIt()
        self.actualLevelCopy = Config.shared.difficulty
        if Session.shared.level.moves.count == 0{
            self.scrabler.moves4Scrable =  20
            performedRandomScramble = true
        }else{
            self.scrabler.moves4Scrable =  0
        }
        self.doScrable()
        self.time = Session.shared.level.time
        if self.time > 0 && !self.isLoadingAFinishedLevel{
            self.startTimer()
        }
        self.askRate = Util.shared.shouldAskForRate(movesCount:Level.getMovesHistoricalCOunt())
        if !self.isCommingFromConfigView{
            self.startCountingToReplicate()
        }
        self.disableColorOptionsIfNeeded()
        self.showLevelName()
        self.handleBluredImageForLegendMode()
        self.handleNextLevelButtonVisibility()
        self.handleTrysLabelVisibility(level:Config.shared.difficulty)
        self.updateDificultyLevel()
        self.proccessAllImageToFindMissingColorsFinished()
        self.wrongColorSelected = Session.shared.level.failedTrys
        self.updateScoreLabel()
        self.handleLoadingLevelFinishel()
        hanldeTimeToNextTriesReduceViibility()
        //self.handleBluredImageForLegendMode()
    }
    func hanldeTimeToNextTriesReduceViibility(){
        let hidden = Config.shared.difficulty == .legend ? true :  Config.shared.difficulty == .alpha_male ? false : true
        if !hidden && self.wrongColorSelected < self.getDifficultyLevelPaintAllowedTrys(){
            self.lblCOuntDonwToNextTryReduce.isHidden = hidden
        }
    }
    func showLevelName(){
        self.levelName.text = Config.shared.difficulty == .legend ? "🦄" :  Config.shared.difficulty == .alpha_male ? "🐺" : "🔥"
    }
    func handleBluredImageForLegendMode(){
        if (Config.shared.difficulty == .legend ){
            self.addBluredImageOverColorOptions()
        }
    }
    func updateDificultyLevel(){
        Config.shared.difficulty = self.actualLevelCopy.rawValue == 0 ? GameDifficultyLevel.brave : self.actualLevelCopy.rawValue == 1 ? GameDifficultyLevel.alpha_male : GameDifficultyLevel.legend
        Config.shared.updateConfigRegisterAt(index:0,updateData:(key:"difficulty_level",value:self.actualLevelCopy.rawValue))
    }
    func disableColorOptionsIfNeeded(){
        let imagesItemUserInteraction:Bool = Config.shared.difficulty == .legend ? false : true
        self.colorsContainerView.isUserInteractionEnabled = imagesItemUserInteraction
        self.blueColorOption.isUserInteractionEnabled = imagesItemUserInteraction
        self.redColorOption.isUserInteractionEnabled = imagesItemUserInteraction
        self.whiteColorOption.isUserInteractionEnabled = imagesItemUserInteraction
        self.greenColorOption.isUserInteractionEnabled = imagesItemUserInteraction
        self.orangeColorOption.isUserInteractionEnabled = imagesItemUserInteraction
        self.yellowColorOption.isUserInteractionEnabled = imagesItemUserInteraction
        //self.handleBluredImageForLegendMode()
        self.selectedColor = nil
        self.removeBorderForAllColorOption()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func EXECRotation(faceOfMoveOrigin:Face,columnMove:cubeColumnMove,moveOrigin:MoveOrigin,index:Int,degrees:degrees,swipeDirection:UISwipeGestureRecognizer.Direction,functionName:String){
        do {
            if self.solveTimer.state != .running && !self.isLoadingAFinishedLevel{
                self.startTimer()
            }
            let r1 = try Bokin3x3x3.ROTATE(faceOfMoveOrigin: faceOfMoveOrigin, columnMove: columnMove, moveOrigin: moveOrigin, index: index, degrees: degrees)
            var tagsArray:Array<Int> = []
            for tag in r1.keys{
                if  let imageView = self.view.viewWithTag(tag) as? UIImageView{
                    let origImage = imageView.image
                    let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                    imageView.image =  tintedImage
                    imageView.tintColor = UICubeColors[r1[tag]!]
                    tagsArray.append(tag)
                }
            }
            if !self.isRecratingCubeState{
                //self.deleteImagesOfLastMove()
                if !self.turningEffect{
                    speech(words: functionName, language: "en-US")
                }
                if self.turningEffect{
                    self.playAudioEffect(fileName: "turningCubeEffect", format: "mp3")
                }
                self.completePercent = self.Bokin3x3x3.getCompletePercent()
                if (Int(self.completePercent) == 100 ){
                    self.solveTimer.stop()
                    self.handleUserSolvedTheCube()
                }
                self.requireNextLevelIfNeeded()
                
            }
        }catch let error{
            print(" Error while rotating: \(error)")
        }
        
    }
 
    func handleUserSolvedTheCube(){
     
    }
    //in order to have a generic func, i-ll use a middle-parse func
    
    //this functions represent all moves using standar nom.
    //represents a B move a face
    
    /*Next functions are use for a 3d Cube, with 3 visible faces every time*/
    //Right  move or known as r
    @objc func R() {
        self.addMoveToHistorical(moveIdentifier:1)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Vertical, moveOrigin: .Frontal, index: 3, degrees: .D90,swipeDirection:.up,functionName:"R.")
    }
    //Left prime move or known as l'
    @objc func L() {
        self.addMoveToHistorical(moveIdentifier:2)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .VerticalP, moveOrigin: .Frontal, index: 1, degrees: .D90,swipeDirection:.down,functionName:"L.")
    }
    //Up move or known as u
    @objc func U() {
        self.addMoveToHistorical(moveIdentifier:3)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .HorizontalP, moveOrigin: .Frontal, index: 3, degrees: .D90,swipeDirection:.left,functionName:"U.")
    }
    //Back prime move or known as b'
    @objc func B() {
        self.addMoveToHistorical(moveIdentifier:4)
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .Vertical, moveOrigin: .Side, index: 1, degrees: .D90,swipeDirection:.up,functionName:"B.")
    }
    //Up move or known as u
    @objc func D() {
        self.addMoveToHistorical(moveIdentifier:5)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .HorizontalP, moveOrigin: .Frontal, index: 1, degrees: .D90,swipeDirection:.left,functionName:"D.")
    }
    //frontal move or known as F
    @objc func F() {
        self.addMoveToHistorical(moveIdentifier:6)
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .VerticalP, moveOrigin: .Side, index: 3, degrees: .D90,swipeDirection:.down,functionName:"F.")
    }
    //Right prime move or known as r'
    @objc func RPrime( ) {
        self.addMoveToHistorical(moveIdentifier:7)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .VerticalP, moveOrigin: .Frontal, index: 3, degrees: .D90,swipeDirection:.down,functionName:"R Prime.")
    }
    //Left prime move or known as l
    @objc func LPrime() {
        self.addMoveToHistorical(moveIdentifier:8)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Vertical, moveOrigin: .Frontal, index: 1, degrees: .D90,swipeDirection:.up,functionName:"L Prime")
    }
    //Up prime move or known as u'
    @objc func UPrime() {
        self.addMoveToHistorical(moveIdentifier:9)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Horizontal, moveOrigin: .Frontal, index: 3, degrees: .D90,swipeDirection:.right,functionName:"U Prime")
    }
    //Back prime move or known as b
    @objc func BPrime() {
        self.addMoveToHistorical(moveIdentifier:10)
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .VerticalP, moveOrigin: .Side, index: 1, degrees: .D90,swipeDirection:.down,functionName:"B Prime")
    }
    //Up prime move or known as u'
    @objc func DPrime() {
        self.addMoveToHistorical(moveIdentifier:11)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Horizontal, moveOrigin: .Frontal, index: 1, degrees: .D90,swipeDirection:.right,functionName:"D Prime")
    }
    //frontal Prime move or known as F'
    @objc func FPrime() {
        self.addMoveToHistorical(moveIdentifier:12)
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .Vertical, moveOrigin: .Side, index: 3, degrees: .D90,swipeDirection:.up,functionName:"F Prime")
    }
    //middel frontal   move or known as ms, with f in the front
    @objc func middleSide() {
        self.addMoveToHistorical(moveIdentifier:13)
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .Vertical, moveOrigin: .Side, index: 2, degrees: .D90,swipeDirection:.up,functionName:"M.")
    }
    
    //middel frontal prime   move or known as ms', with f in the front
    @objc func middleSidePrime() {
        self.addMoveToHistorical(moveIdentifier:14)
        self.EXECRotation(faceOfMoveOrigin: .Right, columnMove: .VerticalP, moveOrigin: .Side, index: 2, degrees: .D90,swipeDirection:.down,functionName:"M Prime")
    }
    //middel frontal prime   move or known as m'
    @objc func middleFrontH() {
        self.addMoveToHistorical(moveIdentifier:15)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .HorizontalP, moveOrigin: .Frontal, index: 2, degrees: .D90,swipeDirection:.left,functionName:"M H.")
    }
    
    //middel frontal prime   move or known as m'
    @objc func middleFrontPrimeH() {
        self.addMoveToHistorical(moveIdentifier:16)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Horizontal, moveOrigin: .Frontal, index: 2, degrees: .D90,swipeDirection:.right,functionName:"M H Prime")
    }
    
    //middel frontal prime   move or known as m'
    @objc func middleFront() {
        self.addMoveToHistorical(moveIdentifier:17)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .VerticalP, moveOrigin: .Frontal, index: 2, degrees: .D90,swipeDirection:.down,functionName:"M.")
    }
    
    //middel frontal prime   move or known as m'
    @objc func middleFrontPrime() {
        self.addMoveToHistorical(moveIdentifier:18)
        self.EXECRotation(faceOfMoveOrigin: .Front, columnMove: .Vertical, moveOrigin: .Frontal, index: 2, degrees: .D90,swipeDirection:.up,functionName:"M Prime")
    }
    func addMoveToHistorical(moveIdentifier:Int){
        if self.shouldAddMove && !self.isLoadingAFinishedLevel{
            if self.shouldCountMove{
                self.movesCount += 1
            }
            self.movesHistorical.append(moveIdentifier)
            Session.shared.level.moves = "\(Session.shared.level.moves!),\(moveIdentifier)"
            self.updateSessionInfo()
        }
    }
    @objc func  rotateWholeCubeRight(){
        self.shouldAddMove = true
        self.shouldCountMove = false
        self.shouldCountSolvePercentEvaluationForSolveCompletion = false
        self.DPrime()
        self.middleFrontPrimeH()
        self.shouldCountSolvePercentEvaluationForSolveCompletion = true
        self.UPrime()
        self.shouldCountMove = true
    }
    @objc func  rotateWholeCubeLeft(){
        self.shouldAddMove = true
        self.shouldCountMove = false
        self.shouldCountSolvePercentEvaluationForSolveCompletion = false
        self.D()
        self.middleFrontH()
        self.shouldCountSolvePercentEvaluationForSolveCompletion = true
        self.U()
        self.shouldCountMove = true
    }
    
    @objc func  rotateWholeCubeUp(){
        self.shouldAddMove = true
        self.shouldCountMove = false
        self.shouldCountSolvePercentEvaluationForSolveCompletion = false
        self.LPrime()
        self.middleFrontPrime()
        self.shouldCountSolvePercentEvaluationForSolveCompletion = true
        self.R()
        self.shouldCountMove = true
    }
    
    @objc func  rotateWholeCubeDown(){
        self.shouldAddMove = true
        self.shouldCountMove = false
        self.shouldCountSolvePercentEvaluationForSolveCompletion = false
        self.RPrime()
        self.middleFront()
        self.shouldCountSolvePercentEvaluationForSolveCompletion = true
        self.L()
        self.shouldCountMove = true
    }
    
    @objc func  fromRightFaceRotateWholeCubeUp(){
        self.shouldAddMove = true
        self.shouldCountMove = false
        self.shouldCountSolvePercentEvaluationForSolveCompletion = false
        self.FPrime()
        self.middleSide()
        self.shouldCountSolvePercentEvaluationForSolveCompletion = true
        self.B()
        self.shouldCountMove = true
    }
    func removeBluredImageIfNoLegendDifficulty(){
        if Config.shared.difficulty != .legend{
            removeBluredImage()
        }
    }
    func removeBluredImage(){
        if let bluredView = self.view.viewWithTag(COLOR_OPTIONS_DISABLER_VIEW_TAG){
            bluredView.removeFromSuperview()
        }
    }
    func addBluredImageOverColorOptions(){
        self.removeBluredImage()
        let bluredView:UIView = UIView(frame: CGRect(x: self.colorsContainerView.frame.minX, y: self.colorsContainerView.frame.minY, width: self.colorsContainerView.frame.width, height: self.colorsContainerView.frame.height))
        bluredView.backgroundColor = UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha: 0.5)
        bluredView.tag = COLOR_OPTIONS_DISABLER_VIEW_TAG
        bluredView.center = self.colorsContainerView.center
        bluredView.roundBorder(by: 10)
        self.view.addSubview(bluredView)
        self.view.bringSubviewToFront(bluredView)
    }
    @objc func  fromRightFaceRotateWholeCubeDown(){
        self.shouldAddMove = true
        self.shouldCountMove = false
        self.shouldCountSolvePercentEvaluationForSolveCompletion = false
        self.F()
        self.middleSidePrime()
        self.shouldCountSolvePercentEvaluationForSolveCompletion = true
        self.BPrime()
        self.shouldCountMove = true
    }
    @objc func showHelp(){
        performSegue(withIdentifier: "cubeToHelpSegueIdentifier", sender: self)
    }
    func doScrable() {
        (self.shouldCountMove,self.isRecratingCubeState) = (false,true)
        let res =  self.scrabler.generateScrable()
        var cubeMove = ""
        for move in res{
            cubeMove = move
            if let indexOfTwo = cubeMove.index(of: "2"){
                cubeMove.remove(at: indexOfTwo)
                performSelector(function: cubeMove, times: 2)
            }else{
                performSelector(function: cubeMove, times: 1)
            }
        }
        (self.shouldCountMove,self.isRecratingCubeState) = (true,false)
    }
    //Execute the inverse move of the  last move
    @objc func undoMove(){
        if let lastMoveIndex = self.movesHistorical.popLast(){
            (self.shouldAddMove,self.shouldCountMove) = (false,false)
            let inverse = self.invert(move: moveIdentifiers[lastMoveIndex]!)
            self.perform(NSSelectorFromString(inverse), with: self)
            (self.shouldAddMove,self.shouldCountMove) = (true,true)
        }
    }
    func getSubstringRemovingLastMove(lastMove:Int)->String{
        let moves:String = Session.shared.level.moves
        guard moves.count > 0 else{
            return ""
        }
        let lastMoveParsed:String = "\(lastMove)"
        let index = moves.index(moves.startIndex, offsetBy: moves.count - lastMoveParsed.count - 1)
        return String(moves.prefix(upTo: index))
    }
    func getRightLastMoveIdentifier()->Int?{
        guard self.movesHistorical.count > 0,self.undoIndexLocation > 0 else{
            return nil
        }
        return self.movesHistorical[self.undoIndexLocation-1]
    }
    func generateStringFromMoveHistorical()->String{
        var result:String = ""
        for identifier in self.movesHistorical{
            result = "\(result),\(identifier)"
        }
        return result
    }
    func updateTimeData(){
        Session.shared.updateSessionRegisterWith(searchTerms: (key:"identifier",value:Session.shared.level.identifier), updateData: (key:"time",value: self.time ))
    }
    func updateSessionInfo(){
        self.updateTimeData()
        Session.shared.updateSessionRegisterWith(searchTerms: (key:"identifier",value:Session.shared.level.identifier), updateData: (key:"moves",value: Session.shared.level.moves ))
    }
   
    func stopTimerUntilViewReAppears(){
        self.solveTimer.stop()
    }
    //get The Inverse equivalent of a move
    func invert(move:String)->String{
        if let inverse = self.movesInverses[move]{
            return inverse
        }else{
            for key in self.movesInverses.keys{
                if move == self.movesInverses[key]!{
                    return key
                }
            }
        }
        return move
    }
    func performSelector(function move:String,times:Int){
        var cont = 0
        while(cont<times){
            perform(Selector(move), with: self)
            cont+=1
        }
    }
    
    /*in order to make it more reallistic, every time a move is goin to be performance, ill give user a grafic tip to know the direction of the move
     also, a delay  when moving(when he is not touching/moving) the cube
     */
    func getHelpArrowImageDimensions(moveDirection:UISwipeGestureRecognizer.Direction)->(width:CGFloat,height:CGFloat){
        var width:CGFloat = 20.0
        var height:CGFloat = 10.0
        if (moveDirection == .left || moveDirection == .right){
            width = 10.0
            height = 20.0
        }
        
        return (width,height)
    }
    
    func deleteImagesOfLastMove(){
        for containerImageTag in self.lastMovedUniqueIdentifiers{
            guard let imageView = self.view.viewWithTag(containerImageTag) as? UIImageView else{
                return
            }
            for view in imageView.subviews{
                view.removeFromSuperview()
            }
        }
        self.lastMovedUniqueIdentifiers.removeAll()
    }
    func getExcludeIdsForHelpArrows(faceOfMoveOrigin:Face,columnMove:cubeColumnMove,moveOrigin:MoveOrigin,ids:Array<Int>)->Array<Int>{
        var result:Array<Int> = Array.init()
        if let excludeFaces = Bokin3x3x3.moveParalelFaces[faceOfMoveOrigin]?[moveOrigin]?[columnMove]{
            for face in excludeFaces{
                result = result + Array(Bokin3x3x3.getUniqueIdentifierFace(face:face).values)
            }
        }
        return result
    }
   
   
    //poin To a item with a given tag with an animated row
   
    func getPointingArrowImagesPrefixesAndLocationAdjust(tag:Int)->(String,(xAdjust:Float,yAdjust:Float)){
        var result:(String,(xAdjust:Float,yAdjust:Float)) = ("",(xAdjust:0,yAdjust:0))
        if let face = self.Bokin3x3x3.faceOfUniqueIdentifierWith(index:tag){
            result = face == "F" ?  ("left_right_arrow_",(xAdjust:-50,yAdjust:-40)) : face == "U" ? ("up_down_arrow_",(xAdjust:0,yAdjust:0)) : face == "R" ? ("right_left_arrow_",(xAdjust:0,yAdjust:-40)) : ("up_dow_arrow_",(xAdjust:0,yAdjust:0))
        }
        return result
    }
    

    
    //this function set tags for images so we can identify each image as an unique time item.
    func addMovesForItemAtUpFace(identifier:Int,movesFunctions:[cubeColumnMove:String]){
        self.stickerGestureMovesEquivalentsByAngle[identifier] = movesFunctions
        
    }
    func setImagestags(){
        self.addMovesForItemAtUpFace(identifier: (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[18])!, movesFunctions: [cubeColumnMove.Horizontal:"F",cubeColumnMove.HorizontalP:"FPrime",cubeColumnMove.Vertical:"R",cubeColumnMove.VerticalP:"RPrime"])
        self.addMovesForItemAtUpFace(identifier: (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[19])!, movesFunctions: [cubeColumnMove.Horizontal:"middleSidePrime",cubeColumnMove.HorizontalP:"middleSide",cubeColumnMove.Vertical:"R",cubeColumnMove.VerticalP:"RPrime",])
        self.addMovesForItemAtUpFace(identifier: (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[20])!, movesFunctions: [cubeColumnMove.Horizontal:"BPrime",cubeColumnMove.HorizontalP:"B",cubeColumnMove.Vertical:"R",cubeColumnMove.VerticalP:"RPrime",])
        self.addMovesForItemAtUpFace(identifier: (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[21])!, movesFunctions: [cubeColumnMove.Horizontal:"F",cubeColumnMove.HorizontalP:"FPrime",cubeColumnMove.Vertical:"middleFrontPrime",cubeColumnMove.VerticalP:"middleFront"])
        self.addMovesForItemAtUpFace(identifier: (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[22])!, movesFunctions: [cubeColumnMove.Horizontal:"middleSidePrime",cubeColumnMove.HorizontalP:"middleSide",cubeColumnMove.Vertical:"middleFrontPrime",cubeColumnMove.VerticalP:"middleFront",])
        self.addMovesForItemAtUpFace(identifier: (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[23])!, movesFunctions: [cubeColumnMove.Horizontal:"BPrime",cubeColumnMove.HorizontalP:"B",cubeColumnMove.Vertical:"middleFrontPrime",cubeColumnMove.VerticalP:"middleFront",])
        self.addMovesForItemAtUpFace(identifier: (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[24])!, movesFunctions: [cubeColumnMove.Horizontal:"F",cubeColumnMove.HorizontalP:"FPrime",cubeColumnMove.Vertical:"LPrime",cubeColumnMove.VerticalP:"L"])
        self.addMovesForItemAtUpFace(identifier: (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[25])!, movesFunctions: [cubeColumnMove.Horizontal:"middleSidePrime",cubeColumnMove.HorizontalP:"middleSide",cubeColumnMove.Vertical:"LPrime",cubeColumnMove.VerticalP:"L",])
        self.addMovesForItemAtUpFace(identifier: (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[26])!, movesFunctions: [cubeColumnMove.Horizontal:"BPrime",cubeColumnMove.HorizontalP:"B",cubeColumnMove.Vertical:"LPrime",cubeColumnMove.VerticalP:"L",])
        self.itemUpPos18.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[18])!
        self.itemUpPos19.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[19])!
        self.itemUpPos20.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[20])!
        self.itemUpPos21.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[21])!
        self.itemUpPos22.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[22])!
        self.itemUpPos23.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[23])!
        self.itemUpPos24.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[24])!
        self.itemUpPos25.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[25])!
        self.itemUpPos26.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Up]?[26])!
        
        self.itemRightPos0.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Right]?[0])!
        self.itemRightPos1.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Right]?[1])!
        self.itemRightPos2.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Right]?[2])!
        self.itemRightPos9.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Right]?[9])!
        self.itemRightPos10.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Right]?[10])!
        self.itemRightPos11.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Right]?[11])!
        self.itemRightPos18.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Right]?[18])!
        self.itemRightPos19.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Right]?[19])!
        self.itemRightPos20.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Right]?[20])!
        
        self.itemFrontPos0.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Front]?[0])!
        self.itemFrontPos3.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Front]?[3])!
        self.itemFrontPos6.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Front]?[6])!
        self.itemFrontPos9.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Front]?[9])!
        self.itemFrontPos12.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Front]?[12])!
        self.itemFrontPos15.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Front]?[15])!
        self.itemFrontPos18.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Front]?[18])!
        self.itemFrontPos21.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Front]?[21])!
        self.itemFrontPos24.tag = (Bokin3x3x3.faceUniqueIdentifiers[Face.Front]?[24])!
    }
    func getGestureRecognizers(selector:String,direction:UISwipeGestureRecognizer.Direction)->UISwipeGestureRecognizer{
        let s = NSSelectorFromString("\(selector)")
        let GR = UISwipeGestureRecognizer(target: self, action: s)
        GR.direction = direction
        return GR
    }
    func getPanGestureRecognizer(selector:String)->UIPanGestureRecognizer{
        let s = NSSelectorFromString("\(selector):")
        let panGesture = UIPanGestureRecognizer(target: self, action: s)
        
        return panGesture
    }
    @objc func pr(_ gestureRecognize: UIGestureRecognizer){
        let panGesture = gestureRecognize as! UIPanGestureRecognizer
        if (gestureRecognize.state == .began){
            self.panRecognizerStartLocation = panGesture.translation(in: panGesture.view!)
        }
        if (gestureRecognize.state == .ended){
            self.panRecognizerEndLocation = panGesture.translation(in: panGesture.view!)
            let move:cubeColumnMove = getMoveDIrectionFromPanGesture(startPoint: CGPoint(x: self.panRecognizerStartLocation.x, y: self.panRecognizerStartLocation.y), endPoint: CGPoint(x: self.panRecognizerEndLocation.x, y: self.panRecognizerEndLocation.y))
            let functionName:String = self.stickerGestureMovesEquivalentsByAngle[(panGesture.view?.tag)!]![move]!
            let function:Selector =  NSSelectorFromString(functionName)
            self.perform(function)
          }
    }
    //animate an item with the colors of another one, will use it to show the user where the item will be
    func putOriginalColorsToRightItem(colorByTag:[Int:UIColor]){
        for data in colorByTag.enumerated(){
            if let imageView = self.view.viewWithTag(data.element.key) as? UIImageView{
                let origImage = imageView.image
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                imageView.image =  tintedImage
                imageView.tintColor =  data.element.value
            }
        }
    }
    func setItemStickerBy(itemsColors:Dictionary<Int,UIColor>){
        for key in itemsColors.keys{
            if let imageView = self.view.viewWithTag(key) as? UIImageView{
                let origImage = imageView.image
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                imageView.image =  tintedImage
                imageView.tintColor =  itemsColors[key]
            }
        }
    }
    func setItemStickerBy(actualUIImages:Dictionary<Int,UIImage>){
        for key in actualUIImages.keys{
            if let imageView = self.view.viewWithTag(key) as? UIImageView{
                let origImage = imageView.image
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                imageView.image =  tintedImage
                imageView.tintColor =  UIColor.gray
            }
        }
    }

 
 
    
    
   
    

    func addGestureRecognizers(){
        
        self.itemUpPos18.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.pr)))
        self.itemUpPos19.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.pr)))
        self.itemUpPos20.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.pr)))
        self.itemUpPos21.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.pr)))
        self.itemUpPos22.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.pr)))
        self.itemUpPos23.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.pr)))
        self.itemUpPos24.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.pr)))
        self.itemUpPos25.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.pr)))
        self.itemUpPos26.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.pr)))
        
        //gestures for Right face
        
         self.itemRightPos0.addGestureRecognizer(self.getGestureRecognizers(selector: "DPrime", direction: .right))
        self.itemRightPos0.addGestureRecognizer(self.getGestureRecognizers(selector: "FPrime", direction: .up))
        self.itemRightPos0.addGestureRecognizer(self.getGestureRecognizers(selector: "D", direction: .left))
        self.itemRightPos0.addGestureRecognizer(self.getGestureRecognizers(selector: "F", direction: .down))
        
        self.itemRightPos1.addGestureRecognizer(self.getGestureRecognizers(selector: "DPrime", direction: .right))
        self.itemRightPos1.addGestureRecognizer(self.getGestureRecognizers(selector: "middleSide", direction: .up))
        self.itemRightPos1.addGestureRecognizer(self.getGestureRecognizers(selector: "D", direction: .left))
        self.itemRightPos1.addGestureRecognizer(self.getGestureRecognizers(selector: "middleSidePrime", direction: .down))
        
        self.itemRightPos2.addGestureRecognizer(self.getGestureRecognizers(selector: "DPrime", direction: .right))
        self.itemRightPos2.addGestureRecognizer(self.getGestureRecognizers(selector: "B", direction: .up))
        self.itemRightPos2.addGestureRecognizer(self.getGestureRecognizers(selector: "D", direction: .left))
        self.itemRightPos2.addGestureRecognizer(self.getGestureRecognizers(selector: "BPrime", direction: .down))
        
        self.itemRightPos9.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontH", direction: .left))
        self.itemRightPos9.addGestureRecognizer(self.getGestureRecognizers(selector: "FPrime", direction: .up))
        self.itemRightPos9.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontPrimeH", direction: .right))
        self.itemRightPos9.addGestureRecognizer(self.getGestureRecognizers(selector: "F", direction: .down))
        
        self.itemRightPos10.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontH", direction: .left))
        self.itemRightPos10.addGestureRecognizer(self.getGestureRecognizers(selector: "middleSide", direction: .up))
        self.itemRightPos10.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontPrimeH", direction: .right))
        self.itemRightPos10.addGestureRecognizer(self.getGestureRecognizers(selector: "middleSidePrime", direction: .down))
        
        self.itemRightPos11.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontH", direction: .left))
        self.itemRightPos11.addGestureRecognizer(self.getGestureRecognizers(selector: "B", direction: .up))
        self.itemRightPos11.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontPrimeH", direction: .right))
        self.itemRightPos11.addGestureRecognizer(self.getGestureRecognizers(selector: "BPrime", direction: .down))
        
        self.itemRightPos18.addGestureRecognizer(self.getGestureRecognizers(selector: "UPrime", direction: .right))
        self.itemRightPos18.addGestureRecognizer(self.getGestureRecognizers(selector: "FPrime", direction: .up))
        self.itemRightPos18.addGestureRecognizer(self.getGestureRecognizers(selector: "U", direction: .left))
        self.itemRightPos18.addGestureRecognizer(self.getGestureRecognizers(selector: "F", direction: .down))
        
        self.itemRightPos19.addGestureRecognizer(self.getGestureRecognizers(selector: "UPrime", direction: .right))
        self.itemRightPos19.addGestureRecognizer(self.getGestureRecognizers(selector: "middleSide", direction: .up))
        self.itemRightPos19.addGestureRecognizer(self.getGestureRecognizers(selector: "U", direction: .left))
        self.itemRightPos19.addGestureRecognizer(self.getGestureRecognizers(selector: "middleSidePrime", direction: .down))
        
        self.itemRightPos20.addGestureRecognizer(self.getGestureRecognizers(selector: "UPrime", direction: .right))
        self.itemRightPos20.addGestureRecognizer(self.getGestureRecognizers(selector: "B", direction: .up))
        self.itemRightPos20.addGestureRecognizer(self.getGestureRecognizers(selector: "U", direction: .left))
        self.itemRightPos20.addGestureRecognizer(self.getGestureRecognizers(selector: "BPrime", direction: .down))
        //gestures for Front face
        self.itemFrontPos0.addGestureRecognizer(self.getGestureRecognizers(selector: "DPrime", direction: .right))
        self.itemFrontPos0.addGestureRecognizer(self.getGestureRecognizers(selector: "R", direction: .up))
        self.itemFrontPos0.addGestureRecognizer(self.getGestureRecognizers(selector: "D", direction: .left))
        self.itemFrontPos0.addGestureRecognizer(self.getGestureRecognizers(selector: "RPrime", direction: .down))
        
        self.itemFrontPos3.addGestureRecognizer(self.getGestureRecognizers(selector: "DPrime", direction: .right))
        self.itemFrontPos3.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFront", direction: .down))
        self.itemFrontPos3.addGestureRecognizer(self.getGestureRecognizers(selector: "D", direction: .left))
        self.itemFrontPos3.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontPrime", direction: .up))
        
        self.itemFrontPos6.addGestureRecognizer(self.getGestureRecognizers(selector: "DPrime", direction: .right))
        self.itemFrontPos6.addGestureRecognizer(self.getGestureRecognizers(selector: "LPrime", direction: .up))
        self.itemFrontPos6.addGestureRecognizer(self.getGestureRecognizers(selector: "D", direction: .left))
        self.itemFrontPos6.addGestureRecognizer(self.getGestureRecognizers(selector: "L", direction: .down))
        
        self.itemFrontPos9.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontH", direction: .left))
        self.itemFrontPos9.addGestureRecognizer(self.getGestureRecognizers(selector: "R", direction: .up))
        self.itemFrontPos9.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontPrimeH", direction: .right))
        self.itemFrontPos9.addGestureRecognizer(self.getGestureRecognizers(selector: "RPrime", direction: .down))
        
        self.itemFrontPos12.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontH", direction: .left))
        self.itemFrontPos12.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontPrime", direction: .up))
        self.itemFrontPos12.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontPrimeH", direction: .right))
        self.itemFrontPos12.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFront", direction: .down))
        
        
        self.itemFrontPos15.addGestureRecognizer(self.getGestureRecognizers(selector: "L", direction: .down))
        self.itemFrontPos15.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontH", direction: .left))
        self.itemFrontPos15.addGestureRecognizer(self.getGestureRecognizers(selector: "LPrime", direction: .up))
        self.itemFrontPos15.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontPrimeH", direction: .right))
        
        self.itemFrontPos18.addGestureRecognizer(self.getGestureRecognizers(selector: "UPrime", direction: .right))
        self.itemFrontPos18.addGestureRecognizer(self.getGestureRecognizers(selector: "R", direction: .up))
        self.itemFrontPos18.addGestureRecognizer(self.getGestureRecognizers(selector: "U", direction: .left))
        self.itemFrontPos18.addGestureRecognizer(self.getGestureRecognizers(selector: "RPrime", direction: .down))
        
        self.itemFrontPos21.addGestureRecognizer(self.getGestureRecognizers(selector: "UPrime", direction: .right))
        self.itemFrontPos21.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFrontPrime", direction: .up))
        self.itemFrontPos21.addGestureRecognizer(self.getGestureRecognizers(selector: "U", direction: .left))
        self.itemFrontPos21.addGestureRecognizer(self.getGestureRecognizers(selector: "middleFront", direction: .down))
        
        self.itemFrontPos24.addGestureRecognizer(self.getGestureRecognizers(selector: "LPrime", direction: .up))
        self.itemFrontPos24.addGestureRecognizer(self.getGestureRecognizers(selector: "UPrime", direction: .right))
        self.itemFrontPos24.addGestureRecognizer(self.getGestureRecognizers(selector: "L", direction: .down))
        self.itemFrontPos24.addGestureRecognizer(self.getGestureRecognizers(selector: "U", direction: .left))
        
        
        //gesture for rotating the entire cube
        self.leftRotateEntireCubeAreaView.addGestureRecognizer(self.getGestureRecognizers(selector: "rotateWholeCubeRight", direction: .right))
        self.leftRotateEntireCubeAreaView.addGestureRecognizer(self.getGestureRecognizers(selector: "rotateWholeCubeLeft", direction: .left))
        self.leftRotateEntireCubeAreaView.addGestureRecognizer(self.getGestureRecognizers(selector: "rotateWholeCubeUp", direction: .up))
        self.leftRotateEntireCubeAreaView.addGestureRecognizer(self.getGestureRecognizers(selector: "rotateWholeCubeDown", direction: .down))
        self.rightRotateEntireCubeAreaView.addGestureRecognizer(self.getGestureRecognizers(selector: "rotateWholeCubeRight", direction: .right))
        self.rightRotateEntireCubeAreaView.addGestureRecognizer(self.getGestureRecognizers(selector: "rotateWholeCubeLeft", direction: .left))
        self.rightRotateEntireCubeAreaView.addGestureRecognizer(self.getGestureRecognizers(selector: "fromRightFaceRotateWholeCubeUp", direction: .up))
        self.rightRotateEntireCubeAreaView.addGestureRecognizer(self.getGestureRecognizers(selector: "fromRightFaceRotateWholeCubeDown", direction: .down))
        //gestures for Up face
        self.itemUpPos18.isUserInteractionEnabled = true
        self.itemUpPos19.isUserInteractionEnabled = true
        self.itemUpPos20.isUserInteractionEnabled = true
        self.itemUpPos21.isUserInteractionEnabled = true
        self.itemUpPos22.isUserInteractionEnabled = true
        self.itemUpPos23.isUserInteractionEnabled = true
        self.itemUpPos24.isUserInteractionEnabled = true
        self.itemUpPos25.isUserInteractionEnabled = true
        self.itemUpPos26.isUserInteractionEnabled = true
        self.itemRightPos0.isUserInteractionEnabled = true
        self.itemRightPos1.isUserInteractionEnabled = true
        self.itemRightPos2.isUserInteractionEnabled = true
        self.itemRightPos9.isUserInteractionEnabled = true
        self.itemRightPos10.isUserInteractionEnabled = true
        self.itemRightPos11.isUserInteractionEnabled = true
        self.itemRightPos18.isUserInteractionEnabled = true
        self.itemRightPos19.isUserInteractionEnabled = true
        self.itemRightPos20.isUserInteractionEnabled = true
        self.itemFrontPos0.isUserInteractionEnabled = true
        self.itemFrontPos3.isUserInteractionEnabled = true
        self.itemFrontPos6.isUserInteractionEnabled = true
        self.itemFrontPos9.isUserInteractionEnabled = true
        self.itemFrontPos12.isUserInteractionEnabled = true
        self.itemFrontPos15.isUserInteractionEnabled = true
        self.itemFrontPos18.isUserInteractionEnabled = true
        self.itemFrontPos21.isUserInteractionEnabled = true
        self.itemFrontPos24.isUserInteractionEnabled = true
        self.leftRotateEntireCubeAreaView.isUserInteractionEnabled = true
        self.rightRotateEntireCubeAreaView.isUserInteractionEnabled = true
    }
    /*
     // MARK: - Audio Function
     }
     */
    func playAudioEffect(fileName:String,format:String){
        guard let path = Bundle.main.path(forResource: fileName, ofType:format) else{
            return
        }
        let url = URL(fileURLWithPath: path)
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            self.player = sound
            sound.numberOfLoops = 0
            sound.prepareToPlay()
            if !sound.isPlaying{
                sound.play()
            }else{
                sound.stop()
            }
        } catch {
            print("error loading file")
        }
        
    }
    
    
    
}
