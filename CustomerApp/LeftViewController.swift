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
    var categories: [String] = []
    var subCategories =  [String: [String]]()
    
    // Data for table view data source
    var expandedIndex =  [Int: Int]()
    var tableData: [String] = []
    
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
        println("ExpandedIndex: \(expandedIndex)")

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
        if (indexPath.row == 0 && indexPath.section == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier(self.placeholderIdentifier) as UITableViewCell
        }
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
        // Expand cells if is a main category
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
                if (categoryIndex > index - 1) {
                    println("categoryIndex: \(categoryIndex)")
                    let oldVal = expandedIndex[categoryIndex]
                    expandedIndex[categoryIndex] = nil
                    expandedIndex[categoryIndex + itemsToAdd.count] = oldVal;
                    println("Set expandedIndex[\(categoryIndex + itemsToAdd.count)] to \(oldVal)")
                }
            }
            println("ExpandedIndex: \(expandedIndex)")
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
                if (categoryIndex > index - 1) {
                    println("categoryIndex: \(categoryIndex)")
                    let oldVal = expandedIndex[categoryIndex]
                    expandedIndex[categoryIndex] = nil
                    expandedIndex[categoryIndex - itemsToRemove.count] = oldVal;
                    println("Set expandedIndex[\(categoryIndex - itemsToRemove.count)] to \(oldVal)")
                }
            }
            println("ExpandedIndex: \(expandedIndex)")
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
