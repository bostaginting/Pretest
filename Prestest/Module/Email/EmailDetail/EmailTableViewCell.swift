//
//  EmailTableViewCell.swift
//  Prestest
//
//  Created by Bosta Ginting on 17/10/20.
//

import UIKit

class EmailTableViewCell: UITableViewCell {

    @IBOutlet weak var viewEmailStatus: UIView!
    @IBOutlet weak var labelEmailContent: UILabel!
    @IBOutlet weak var labelEmailDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewEmailStatus.layer.cornerRadius = viewEmailStatus.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
