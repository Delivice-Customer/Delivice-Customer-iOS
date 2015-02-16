//
//  RightViewController.swift
//  CustomerApp
//
//  Created by Tong on 2/13/15.
//  Copyright (c) 2015 Delivice. All rights reserved.
//

import UIKit

@objc
protocol RightViewControllerDelegate {
    
    optional func toggleRightPanel()
    
}

class RightViewController: UIViewController, CenterViewControllerDelegate {

    @IBOutlet weak var backButton: UIButton!
    
    var delegate: RightViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func backToCenter(sender: AnyObject) {
        delegate?.toggleRightPanel?()
    }
}