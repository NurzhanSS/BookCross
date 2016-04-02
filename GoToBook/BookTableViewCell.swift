//
//  BookTableViewCell.swift
//  GoToBook
//
//  Created by Nurzhan Sagyndyk on 02.04.16.
//  Copyright © 2016 Nurzhan Sagyndyk. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    @IBOutlet weak var BookNameLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
