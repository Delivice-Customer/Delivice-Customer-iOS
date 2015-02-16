//
//  CenterViewController.swift
//  CustomerApp
//
//  Created by Tong on 2/12/15.
//  Copyright (c) 2015 Delivice. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

@objc
protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
}

class CenterViewController: UIViewController, LeftViewControllerDelegate {

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var addOne: UITextField!
    
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
    
    var count = 0;
    @IBAction func buttonPressed(sender: UIButton)
    {
        var color = UIColor(red: 0xff, green: 0x5b, blue: 0x40)
        addOne.backgroundColor = color;
        addOne.hidden = false;
        count++;
        addOne.text = String(count);
    }
    
    // LeftViewControllerDelegate method
    func categorySelected(category: String) {
        println("captured")
        self.textLabel.text = category
        delegate?.toggleLeftPanel?()
    }
    
}