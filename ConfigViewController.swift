//
//  ConfigViewController.swift
//  RubikCubePaint
//
//  Created by Pedro Luis Cabrera Acosta on 9/5/18.
//  Copyright © 2018 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {
    var levelDescriptionData:[Int:String] = [:]
    @IBOutlet weak var levelSegmentedControl: UISegmentedControl!
    @IBOutlet weak var levelDescription: UILabel!
    @IBOutlet weak var titleDescription: UILabel!
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLevelDescriptionData()
        self.titleDescription.text = NSLocalizedString("Difficulty Level", comment: "")
        self.levelSegmentedControl.selectedSegmentIndex = Config.shared.difficulty.rawValue
        self.levelDescription.text = self.levelDescriptionData[Config.shared.difficulty.rawValue]!
        self.levelSegmentedControl.setTitle("\(NSLocalizedString("Brave", comment: "")) 🔥", forSegmentAt: 0)
        self.levelSegmentedControl.setTitle("\(NSLocalizedString("Alfa-Male", comment: "")) 🐺", forSegmentAt: 1)
        self.levelSegmentedControl.setTitle("\(NSLocalizedString("Legend", comment: "")) 🦄", forSegmentAt: 2)
        self.playBtn.setTitle("\(NSLocalizedString("PLAY", comment: ""))", for: .normal)
     }
    func shouldHideRestartButton()->Bool{
        if FIRST_TIME_APP_SHOWS{ return true }
        return false
    }
    func setLevelDescriptionData(){
        levelDescriptionData[0] =  "🔥: \(NSLocalizedString("Your goal is to solve the cube, there are missing pieces, you can paint them, but the number of attempts you have to paint is limited to the number of missing pieces. Do not fail any attempt.", comment: ""))"
        levelDescriptionData[1] = "🐺: \(NSLocalizedString("Your goal is to solve the cube, there are missing pieces, you can paint them, but the number of attempts you have to paint decreases by 1 each minute. Hurry or you will run out of attempts.", comment: ""))"
        levelDescriptionData[2] = "🦄: \(NSLocalizedString("Your goal is to solve the cube, there are missing pieces, you can not paint them, which increases the difficulty with each finished level. Good luck Legend.", comment: ""))"
    }
    
    @IBAction func backToCube(_ sender: UIButton) {
        self.goToCube()
    }
    func goToCube(){
        if FIRST_TIME_APP_SHOWS{
            self.performSegue(withIdentifier: "configTpGameSegueIdentifier", sender: self)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func play(_ sender: Any) {
        self.goToCube()
    }
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        Config.shared.difficulty = sender.selectedSegmentIndex == 0 ? GameDifficultyLevel.brave : sender.selectedSegmentIndex == 1 ? GameDifficultyLevel.alpha_male : GameDifficultyLevel.legend
        Config.shared.updateConfigRegisterAt(index:0,updateData:(key:"difficulty_level",value:sender.selectedSegmentIndex))
        self.levelDescription.text = self.levelDescriptionData[sender.selectedSegmentIndex]!
    }
    func getMessageForRestart()->String{
        return "If you restart, you will lose all your progress at the \(Config.shared.difficulty.toString()) level. So far you go for the \(self.getSolvedLevelsFor(gameDifficulty: Config.shared.difficulty)). "
    }
    func getSolvedLevelsFor(gameDifficulty:GameDifficultyLevel)->Int{
        let levels = Level.getLevelsCountFor(dificulty_level: gameDifficulty.toString())
        return levels >= LEVELS_PER_DIFFICULTY ? levels % LEVELS_PER_DIFFICULTY : levels
    }
    
    @IBAction func restart(_ sender: Any) {
        self.handleRestart()
    }
    func handleRestart(){
        let alert = UIAlertController(title: NSLocalizedString("Restart", comment: "") , message: NSLocalizedString(self.getMessageForRestart(), comment: "")  , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Restart", comment: "") , style: UIAlertAction.Style.default, handler: ({ alert in
            Level.deleteLevelsFor(dificulty_level: Config.shared.difficulty.toString())
            self.dismiss(animated: true, completion: nil)
        })))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "")  , style: UIAlertAction.Style.default, handler:({ alert in
            
        })))
        alert.view.backgroundColor = UIColor.black
        self.present(alert, animated: true, completion: nil)
    }
}
