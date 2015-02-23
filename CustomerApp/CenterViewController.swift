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
       
        /* Code to add items to product table
        let azureDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let client = azureDelegate.client!
        let productsTable = client.tableWithName("products")

        let item = ["name": "Oranges", "category": "Fruits", "price": 1.99, "store": "Kroger"]
        
        productsTable.insert(item, completion: {(insertedItem, error) in
                if (error != nil){
                    println("error: \(error)")
                }
                else{
                    println("Success!")
                }
            }
        )
        */
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
    
    // Method to add 1 to item count on tap
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
        // Get category items from the database here
        let azureDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let client = azureDelegate.client!
        let productsTable = client.tableWithName("products")
        
        productsTable.readWithPredicate(NSPredicate(format: "category == %@", category),
            completion: {(items, totalCount, error) in
                var dataString = ""
                for item in items {
                    let name = item["name"] as String
                    let price = item["price"] as Float
                    let store = item["store"] as String
                    dataString += "[\(name): $\(price) at \(store)] \n"
                }
                self.textLabel.text = dataString
            }
        )
        
        // Collapse back to main panel
        delegate?.toggleLeftPanel?()
    }
    
}