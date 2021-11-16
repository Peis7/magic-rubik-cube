//
//  ChallengeViewController.swift
//  RubikCubePaint
//
//  Created by Pedro Luis Cabrera Acosta on 9/25/18.
//  Copyright © 2018 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController {
    @IBOutlet weak var challengeLbl: UILabel!
    @IBOutlet weak var challengeQuestionLbl: UILabel!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.challengeLbl.text = NSLocalizedString("The traditional cube is not enough of a challenge for you? Let's make things more interesting by adding extra difficulty.", comment: "")
        self.challengeQuestionLbl.text = NSLocalizedString("do you accept the challenge?", comment: "")
        self.yesBtn.setTitle(NSLocalizedString("YES", comment: ""), for: .normal)
        self.noBtn.setTitle(NSLocalizedString("NO", comment: ""), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func yes(_ sender: UIButton) {
        self.presentGameVIewController()
    }
    @IBAction func no(_ sender: UIButton) {
        self.presentGameVIewController()
    }
    func presentGameVIewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "ConfigViewControllerIdentifier")
        self.present(initialViewController, animated: true, completion: nil)
    }

}
