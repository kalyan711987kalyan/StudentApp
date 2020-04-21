//
//  VideosTableViewCell.swift
//  Student App
//
//  Created by kalyan on 20/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
protocol delVideoCellDelegate : class {
    func diddeleteVideoButton(_ tag: Int)
}
class VideosTableViewCell: UITableViewCell {
    var cellDelegate: delVideoCellDelegate?
    @IBOutlet weak var dataShowLb: UILabel!
    
    @IBOutlet weak var videoNameLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var deleteVideoBtnOutlet: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteVideo(_ sender: Any) {
        cellDelegate?.diddeleteVideoButton((sender as AnyObject).tag)

    }
}
