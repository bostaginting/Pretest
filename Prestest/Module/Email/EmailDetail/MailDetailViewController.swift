//
//  MailDetailViewController.swift
//  Prestest
//
//  Created by Bosta Ginting on 15/10/20.
//

import UIKit
import WebKit

class MailDetailViewController: UIViewController {

    @IBOutlet weak var labelEmailContent: UILabel!
    
    @IBOutlet weak var webViewDetail: WKWebView!
    
    var emailDetail = ""
    var htmlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelEmailContent.text = emailDetail
        webViewDetail.loadHTMLString(htmlString, baseURL: nil)
    }
}
