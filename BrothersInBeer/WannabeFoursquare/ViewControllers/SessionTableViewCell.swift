//
//  SessionTableViewCell.swift
//  WannabeFoursquare
//
//  Created by Cenda on 12/02/2020.
//  Copyright © 2020 CVUT. All rights reserved.
//

import UIKit

class SessionTableViewCell: UITableViewCell {

    @IBOutlet weak var pubName: UILabel!
    var cellVM: CellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
