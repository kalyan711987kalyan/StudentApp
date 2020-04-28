//
//  DownloadedBookTableViewCell.swift
//  Student App
//
//  Created by kalyan on 08/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
protocol downloadedCellDelegate : class {
    func didDeletePressButton(_ tag: Int)
    func didshowImagePressButton(_ tag: Int)
}
class DownloadedBookTableViewCell: UITableViewCell {
    var cellDelegate: downloadedCellDelegate?

    @IBOutlet weak var bookNameLB: UILabel!
    @IBOutlet weak var bookTypeLB: UILabel!
    @IBOutlet weak var seriesLB: UILabel!
    @IBOutlet weak var deleteBookbtn: UIButton!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var classLB: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var desLB: UILabel!
    
    @IBOutlet weak var showImageBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteBtnAction(_ sender: Any) {
        cellDelegate?.didDeletePressButton((sender as AnyObject).tag)
    }
    @IBAction func showFullImageBtnAction(_ sender: Any) {
        cellDelegate?.didshowImagePressButton((sender as AnyObject).tag)

    }
}
