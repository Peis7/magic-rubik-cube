//
//  LevelOptionsTableViewCell.swift
//  RubikCubePaint
//
//  Created by Pedro Luis Cabrera Acosta on 3/10/19.
//  Copyright © 2019 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit

protocol LevelOptionsDelegate {
    func changeDifficultyLevel(index:Int);
}
class LevelOptionsTableViewCell: UITableViewCell {
    var delegate:LevelOptionsDelegate? = nil
    @IBOutlet weak var dificultyLevels: UISegmentedControl!
    func setTranslatedNames(){
        self.dificultyLevels.setTitle("\(NSLocalizedString("Brave", comment: "")) 🔥", forSegmentAt: 0)
        self.dificultyLevels.setTitle("\(NSLocalizedString("Alfa-Male", comment: "")) 🐺", forSegmentAt: 1)
        self.dificultyLevels.setTitle("\(NSLocalizedString("Legend", comment: "")) 🦄", forSegmentAt: 2)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dificultyLevels.selectedSegmentIndex = Config.shared.difficulty == .brave ? 0 : Config.shared.difficulty == .alpha_male ? 1 : 2
        self.setTranslatedNames()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func levelDIfficultyChanged(_ sender: UISegmentedControl) {
        delegate?.changeDifficultyLevel(index:sender.selectedSegmentIndex)
    }
    
}
