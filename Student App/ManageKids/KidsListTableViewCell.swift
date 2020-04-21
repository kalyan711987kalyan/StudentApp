//
//  KidsListTableViewCell.swift
//  Student App
//
//  Created by kalyan on 08/03/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
protocol manageKidCellDelegate : class {
    func editKidPressButton(_ tag: Int)
    func deleteKidPressButton(_ tag: Int)

}
class KidsListTableViewCell: UITableViewCell {
    var cellDelegate: manageKidCellDelegate?

    @IBOutlet weak var kidNameValueLB: UILabel!
    @IBOutlet weak var kidSchoolValueLB: UILabel!
    @IBOutlet weak var kidClassValueLB: UILabel!

    @IBOutlet weak var deleteCellOutlet: UIButton!
    @IBOutlet weak var editCellOutlet: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func editKidBtnAction(_ sender: Any) {
        cellDelegate?.editKidPressButton((sender as AnyObject).tag)

    }
    @IBAction func deleteKidBtnActn(_ sender: Any) {
        cellDelegate?.deleteKidPressButton((sender as AnyObject).tag)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
