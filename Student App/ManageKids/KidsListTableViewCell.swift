//
//  KidsListTableViewCell.swift
//  Student App
//
//  Created by kalyan on 08/03/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit

class KidsListTableViewCell: UITableViewCell {

    @IBOutlet weak var kidNameValueLB: UILabel!
    @IBOutlet weak var kidSchoolValueLB: UILabel!
    @IBOutlet weak var kidClassValueLB: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func editKidBtnAction(_ sender: Any) {
    }
    @IBAction func deleteKidBtnActn(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
