//
//  ColorCollectionViewCell.swift
//  RubikCubePaint
//
//  Created by Pedro Luis Cabrera Acosta on 8/1/18.
//  Copyright © 2018 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit
protocol ColorSelectorDelegate{
    func selectColor(color:UIColor)
}
class ColorCollectionViewCell: UICollectionViewCell {
    var delegate:ColorSelectorDelegate? = nil
    func shapeView(superViewFrame:CGRect){
        self.frame = CGRect(x: self.frame.minX+10, y: self.frame.minY+10, width: self.frame.width , height: self.frame.height)
    }
    func setBorder(radius:Float){
        self.layer.cornerRadius = CGFloat(radius)
    }
    func setBackground(color:UIColor){
        self.backgroundColor = color
    }
    func setBorder(color:UIColor){
        self.layer.borderWidth = 2.0
        self.layer.borderColor = color.cgColor
    }
    func setBorder(width:CGFloat){
        self.layer.borderWidth = width
    }
    
}


