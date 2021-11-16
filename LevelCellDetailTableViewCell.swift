//
//  LevelCellDetailTableViewCell.swift
//  RubikCubePaint
//
//  Created by Pedro Luis Cabrera Acosta on 3/10/19.
//  Copyright © 2019 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit

class LevelCellDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var solvedIcon: UIImageView!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var timesEverSolved: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
