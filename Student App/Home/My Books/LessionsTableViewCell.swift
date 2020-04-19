//
//  LessionsTableViewCell.swift
//  Student App
//
//  Created by kalyan on 09/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
protocol addFavouriteCellDelegate : class {
    func didFavouritePressButton(_ tag: Int)
}
class LessionsTableViewCell: UITableViewCell {
  var cellDelegate: addFavouriteCellDelegate?
    @IBOutlet weak var lessaonNameLb: UILabel!
    @IBOutlet weak var learnings: UILabel!
    @IBOutlet weak var activitiesLb: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addFavouriteBtn(_ sender: Any) {
        cellDelegate?.didFavouritePressButton((sender as AnyObject).tag)
       
    }
}
