//
//  LevelsTableViewController.swift
//  RubikCubePaint
//
//  Created by Pedro Luis Cabrera Acosta on 3/10/19.
//  Copyright © 2019 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit

class LevelsTableViewController: UITableViewController,LevelOptionsDelegate{
    
    
    var solvedLevelsTimer:XTimer! = nil
    var timeShouldTryToLoadSolvedData:Float = 0
    let dateFormatterPrint = DateFormatter()
    var difficulty:GameDifficultyLevel = GameDifficultyLevel.legend
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatterPrint.dateFormat = "MM-dd-yyyy"
        difficulty = Config.shared.difficulty
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.solvedLevelsTimer = XTimer(kind: .rubik)
        self.tryToLoadDataFromServer()
        self.navigationItem.title = "\(NSLocalizedString("World Records", comment: "")) 🌎"
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SolvedData.shared.data[difficulty.toString()] != nil ? SolvedData.shared.data[difficulty.toString()]!.count + 1 : 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 80 :100
    }
    func loadDataFromServer(){
        SolvedData.shared.getData()
    }
    func tryToLoadDataFromServer(){
        self.loadDataFromServer()
        self.solvedLevelsTimer.start(timeInterval: 0.1, target: self, selector: #selector(self.setSolvedLevelCount), userInfo: nil, repeats: true)
    }
    func stopTryingToLoadData(){
        self.solvedLevelsTimer.stop()
    }
    @objc func setSolvedLevelCount(){
        if SolvedData.shared.responseRecived == true && SolvedData.shared.data.count > 0{
            self.tableView.reloadData()
            self.stopTryingToLoadData()
        }
        if  self.timeShouldTryToLoadSolvedData > 10.0{
            self.timeShouldTryToLoadSolvedData = 0
            self.stopTryingToLoadData()
        }
        self.timeShouldTryToLoadSolvedData += 0.1
    }
    func getSolvedTimeFormated(time:Double)->String{
        return "\(String(format: "%02i", time.convertTimeInSecondsToMinutes())):\(String(format: "%02i", Int(time.getSecondsWithTreshHold(treshHold:60.0))))"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellLevelOptionsIdentifier", for: indexPath) as! LevelOptionsTableViewCell
            cell.delegate = self
            cell.selectionStyle = UITableViewCell.SelectionStyle.none;
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetailIdentifier", for: indexPath) as! LevelCellDetailTableViewCell
            if let difficultyData = SolvedData.shared.data[difficulty.toString()],let times = difficultyData["\(indexPath.row)"]{
                if let level = Level.getFinishedLevelFor(dificulty_level:self.difficulty.toString(), missingPeaces: indexPath.row) {
                    cell.stateLbl.text = "\(NSLocalizedString("Finished by you in", comment: "")) \(getSolvedTimeFormated(time:level.time))"
                    cell.solvedIcon.isHidden = false
                    cell.backgroundColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                }else{
                    //cell.timesEverSolved.textColor = UIColor.white
                    cell.levelLbl.textColor = UIColor.white
                    cell.stateLbl.text = "\(NSLocalizedString("You have not solved it yet", comment: ""))"
                    cell.solvedIcon.isHidden = true
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                    cell.backgroundColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
                    if (Level.getLevelsCountFor(dificulty_level :difficulty.toString()) == indexPath.row){
                        cell.stateLbl.text = "\(NSLocalizedString("Currently Solving", comment: ""))"
                        cell.backgroundColor = UIColor(red: 8/255, green: 69/255, blue: 65/255, alpha: 1)
                    }
                }
                cell.timesEverSolved.text = times > 0 ? "\(times) \(NSLocalizedString("People have solved it", comment: ""))" : "\(NSLocalizedString("No one has ever solved it", comment: ""))"
                cell.levelLbl.text = "\(NSLocalizedString("Level", comment: "")) \(indexPath.row)"
            }
            return cell
        }
    }
    
    @IBAction func reloadDataFromServer(_ sender: Any) {
        if self.solvedLevelsTimer.state != .running{
            self.tryToLoadDataFromServer()
        }
    }
    func changeDifficultyLevel(index: Int) {
        self.difficulty = index == 0 ? GameDifficultyLevel.brave : index == 1 ? GameDifficultyLevel.alpha_male : GameDifficultyLevel.legend
        self.tableView.reloadData()
    }
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
