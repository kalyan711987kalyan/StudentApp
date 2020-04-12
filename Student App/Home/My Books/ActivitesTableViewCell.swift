//
//  ActivitesTableViewCell.swift
//  Student App
//
//  Created by kalyan on 12/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
protocol videoCellDelegate : class {
    func didDownloadPressButton(_ tag: Int)
}
class ActivitesTableViewCell: UITableViewCell {
    var videoDelegate: videoCellDelegate?

    @IBOutlet weak var dataCellLb: UILabel!
    @IBOutlet weak var videoTitleBtn: UIButton!
    @IBOutlet weak var downloadBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func downloadBtnAction(_ sender: Any) {
        videoDelegate?.didDownloadPressButton((sender as AnyObject).tag)

    }
    
    @IBAction func videTiteBtnAction(_ sender: Any) {
    }
}
