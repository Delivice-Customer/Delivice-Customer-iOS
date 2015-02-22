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
    
    // Category & subcategory data goes here
    var categories: [String] = []
    var subCategories =  [String: [String]]()
    
    // Data for table view data source
    var tableData: [String] = []
    
    // Keys are indexes of all the main categories
    // Values are the number of subcells that are currently being displayed for that category
    var expandedIndex =  [Int: Int]()

    // Load data -- this code can be changed to pull from the database in the future
    func initCategoryData() {
        // Load main categories
        categories = ["Produce", "Meats & Seafood", "Dairy & Eggs"]
        // Load subcategories
        subCategories["Produce"] = ["Fruits", "Vegetables"]
        subCategories["Meats & Seafood"] = ["Red Meat", "White Meat"]
        subCategories["Dairy & Eggs"] = ["Milk", "Cheese", "Eggs"]
        
        // Put initial items into tableData
        tableData = categories
        // Put indexes of expanded categories into expandedIndex
        for i in 0...categories.count - 1 {
            expandedIndex[i] = 0
        }
    }
    
    // Generated methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCategoryData()
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
        return tableData.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        // Placeholder cell
        if (indexPath.row == 0 && indexPath.section == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier(self.placeholderIdentifier) as UITableViewCell
        }
        // If the index of the cell (minus one due to placeholder) is in the hash of main indicies
        else if (contains(expandedIndex.keys.array, indexPath.row - 1)) {
            cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as UITableViewCell
            cell.textLabel?.text = tableData[indexPath.row - 1]
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier(self.subCellIdentifier) as UITableViewCell
            cell.textLabel?.text = tableData[indexPath.row - 1]
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        // If is placeholder cell, do nothing
        if (cell.reuseIdentifier == placeholderIdentifier) {
            return
        }
        // Expand/collapse cells if is a main category
        else if (cell.reuseIdentifier == cellIdentifier) {
            let indexPathsToChange = makePathsArr(indexPath, category: cell.textLabel!.text!)
            if (expandCategoryIntoTableData(cell.textLabel!.text!, index: indexPath.row)){
                tableView.insertRowsAtIndexPaths(indexPathsToChange, withRowAnimation: UITableViewRowAnimation.Top)
            }
            else {
                tableView.deleteRowsAtIndexPaths(indexPathsToChange, withRowAnimation: UITableViewRowAnimation.Top)
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)

        }
        // Collapse to main view if is a subcategory
        else if (cell.reuseIdentifier == subCellIdentifier) {
            delegate?.categorySelected(tableData[indexPath.row - 1])
        }
    }
    
    // Returns true if items were added to tabledata, false if items were removed
    func expandCategoryIntoTableData(category: String, index: Int) -> Bool {
        // Check if category is already expanded
        if (expandedIndex[index - 1] == 0) {
            // Add subcategories to tableData
            let itemsToAdd = subCategories[category] as [String]!
            for i in 0...itemsToAdd!.count - 1 {
                tableData.insert(itemsToAdd[i], atIndex: index + i)
            }
            // Update expandedIndex dictionary
            expandedIndex[index - 1] = itemsToAdd.count
            let originalKeys = expandedIndex.keys
            for categoryIndex in originalKeys {
                // Update values for main cells that come after the changed cell
                if (categoryIndex > index - 1) {
                    let oldVal = expandedIndex[categoryIndex]
                    expandedIndex[categoryIndex] = nil
                    expandedIndex[categoryIndex + itemsToAdd.count] = oldVal;
                }
            }
            return true
        }
        else {
            let itemsToRemove = subCategories[category] as [String]!
            for i in 0...itemsToRemove!.count - 1 {
                tableData.removeAtIndex(index)
            }
            // Update expandedIndex dictionary
            expandedIndex[index - 1] = 0
            let originalKeys = expandedIndex.keys
            for categoryIndex in originalKeys {
                // Update values for main cells that come after the changed cell
                if (categoryIndex > index - 1) {
                    let oldVal = expandedIndex[categoryIndex]
                    expandedIndex[categoryIndex] = nil
                    expandedIndex[categoryIndex - itemsToRemove.count] = oldVal;
                }
            }
            return false
        }
    }
    
    func makePathsArr(initialPath: NSIndexPath, category: String) -> [NSIndexPath] {
        let length = subCategories[category]!.count
        var paths = [NSIndexPath]()
        for i in 1...length {
            paths.append(NSIndexPath(forItem: initialPath.row + i, inSection: 0))
        }
        return paths
    }
    
}
