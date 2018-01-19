//
//  AboutGameViewController.swift
//  BullsEye
//
//  Created by Derrick Ho on 1/18/18.
//  Copyright © 2018 Derrick Ho. All rights reserved.
//

import UIKit

class AboutGameViewController: UIViewController {
 
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = Bundle.main.url(forResource: "BullsEye", withExtension: "html")
            , let htmlData = try? Data(contentsOf: url)
        {
            let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
            self.webView.load(htmlData, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: baseURL)
        }
    }
    
    @IBAction func tappedClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
