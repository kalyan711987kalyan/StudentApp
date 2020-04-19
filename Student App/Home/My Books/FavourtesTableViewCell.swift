//
//  FavourtesTableViewCell.swift
//  Student App
//
//  Created by kalyan on 17/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
protocol delFavCellDelegate : class {
    func diddeleteFromFavButton(_ tag: Int)
}
class FavourtesTableViewCell: UITableViewCell {
    var cellDelegate: delFavCellDelegate?

    @IBOutlet weak var learningsLB: UILabel!
    @IBOutlet weak var activityLB: UILabel!
    @IBOutlet weak var favBTNOutlet: UIButton!
    @IBOutlet weak var lessonName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func favouriteBtnactn(_ sender: Any) {
        cellDelegate?.diddeleteFromFavButton((sender as AnyObject).tag)

    }
}
