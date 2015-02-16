//
//  LeftViewController.swift
//  CustomerApp
//
//  Created by Tong on 2/12/15.
//  Copyright (c) 2015 Delivice. All rights reserved.
//

import UIKit

@objc
protocol LeftViewControllerDelegate {
    func categorySelected(category: String)
}

class LeftViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Properties
    let cellIdentifier = "Cell"
    let subCellIdentifier = "SubCell"
    let placeholderIdentifier = "Placeholder"
    
    var delegate: LeftViewControllerDelegate?
    
    // Initialize category & subcategory data
    var categories: [String] = ["Produce", "Meats & Seafood", "Dairy & Eggs"]
    var subCategories =  [String: [String]]()
    
    func loadCategoryData() {
        subCategories["Produce"] = ["Fruits", "Vegetables"]
        subCategories["Meats & Seafood"] = ["Red Meat", "White Meat"]
        subCategories["Dairy & Eggs"] = ["Milk", "Cheese", "Eggs"]
    }
    
    // Generated methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategoryData()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Table View Methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        if (indexPath.row == 0 && indexPath.section == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier(self.placeholderIdentifier) as UITableViewCell
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as UITableViewCell
            cell.textLabel?.text = categories[indexPath.row - 1]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row > 0) {
            delegate?.categorySelected(categories[indexPath.row - 1])
        }
    }
    
}
