//
//  EachColorCell.swift
//  CorrectIt
//
//  Created by 北村 開 on 2019/01/22.
//  Copyright © 2019 HimawariClass. All rights reserved.
//

import UIKit

class EachColorCell: UITableViewCell {
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var exLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
