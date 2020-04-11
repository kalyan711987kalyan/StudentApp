//
//  MyBookSeriesTableViewCell.swift
//  Student App
//
//  Created by kalyan on 22/03/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit

class MyBookSeriesTableViewCell: UITableViewCell {
    @IBOutlet weak var textLabelis: UILabel!
    
    @IBOutlet weak var bookseriesImageView: UIImageView!
    
    @IBOutlet weak var selectBookBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        super.layoutSubviews()
        bookseriesImageView.contentMode = .scaleAspectFill;

        //contentView.addSubview(bookseriesImageView)

        self.contentView.layoutIfNeeded()
        //bookseriesImageView.layer.cornerRadius = bookseriesImageView.bounds.height / 2.0
       // bookseriesImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
