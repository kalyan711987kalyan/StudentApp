//
//  LessionsTableViewCell.swift
//  Student App
//
//  Created by kalyan on 09/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit

class LessionsTableViewCell: UITableViewCell {

    @IBOutlet weak var lessaonNameLb: UILabel!
    @IBOutlet weak var learnings: UILabel!
    @IBOutlet weak var activitiesLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
