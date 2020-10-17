//
//  MailDetailViewController.swift
//  Prestest
//
//  Created by Bosta Ginting on 15/10/20.
//

import UIKit

class MailDetailViewController: UIViewController {

    @IBOutlet weak var labelEmailContent: UILabel!
    
    var emailDetail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelEmailContent.text = emailDetail

    }
}
