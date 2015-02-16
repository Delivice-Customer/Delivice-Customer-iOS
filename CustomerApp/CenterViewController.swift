//
//  CenterViewController.swift
//  CustomerApp
//
//  Created by Tong on 2/12/15.
//  Copyright (c) 2015 Delivice. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
   
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
    
}

class CenterViewController: UIViewController {

    @IBOutlet weak var LeftButton: UIButton!
    @IBOutlet weak var RightButton: UIButton!
    
    var delegate: CenterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button actions
    
    @IBAction func showLeft(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    
    @IBAction func showRight(sender: AnyObject) {
        delegate?.toggleRightPanel?()
    }
    
}