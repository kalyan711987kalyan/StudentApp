//
//  BooksListTableViewCell.swift
//  Student App
//
//  Created by kalyan on 29/03/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
protocol YourCellDelegate : class {
    func didPressButton(_ tag: Int)
    func didPressDownloadButton(_ tag: Int)

}
class BooksListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var downloadBtnAction: UIButton!
    var cellDelegate: YourCellDelegate?
    @IBOutlet weak var bookNameLB: UILabel!
    @IBOutlet weak var bookTypeLB: UILabel!
    @IBOutlet weak var imageBTN: UIButton!
    @IBOutlet weak var descriptionLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func thumbnailBtnAction(_ sender: Any) {
        cellDelegate?.didPressButton((sender as AnyObject).tag)
    }
    
    @IBAction func downloadBtnAction(_ sender: Any) {
        cellDelegate?.didPressDownloadButton((sender as AnyObject).tag)

    }
}
