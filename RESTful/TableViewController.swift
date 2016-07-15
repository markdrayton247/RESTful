//
//  TableViewController.swift
//  RESTful
//
//  Created by Mark Drayton on 14/07/2016.
//  Copyright © 2016 Mark Drayton Ltd. All rights reserved.
//

import UIKit

struct DataItem {
    var title: String
    var createdDate: String
    var id: String
}

    
class DataItems:NSObject {
    var items: [DataItem]
    init(items: [DataItem]) {
        self.items = items
    }
}


class TableViewController: UITableViewController, UpdateTitleDelegate {
    
    let RESTcontroller = RESTfulController()
    let nullItem = DataItem(title: "", createdDate: "", id: "")
    let nullArray = [DataItem]()
    var dataItems = DataItems(items: [DataItem]())
    var collectionURL : String = "http://droplet1:3000/items"

    @IBAction func refreshButton(sender: AnyObject) {
        RESTcontroller.fetch(collectionURL, dataItems: dataItems)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableViewController.performRefresh), name: "newValues", object: nil)
        RESTcontroller.fetch(collectionURL, dataItems: dataItems)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func performRefresh() {
        tableView.reloadData()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editTitle" {
            
            let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
            let editVC: EditViewController = segue.destinationViewController as! EditViewController
            editVC._title = dataItems.items[indexPath.row].title
            editVC._id = dataItems.items[indexPath.row].id
            editVC.delegate = self
        }
        else if segue.identifier == "addTitle" {
            
            let editVC: EditViewController = segue.destinationViewController as! EditViewController
            editVC._title = ""
            editVC._id = ""
            editVC.delegate = self
        }
        
    }
    
    
    func writeValueBack(title: String, id: String) {
        
        if (id != ""){
            
            for (index,item) in dataItems.items.enumerate() where item.id == id {
                dataItems.items[index].title = title
            }
            RESTcontroller.update(title, id: id, collectionURL: collectionURL, dataItems: self.dataItems)
            
        } else {
            
            RESTcontroller.create(title, collectionURL: collectionURL, dataItems: self.dataItems)
            
        }
    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataItems.items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dataCell = tableView.dequeueReusableCellWithIdentifier("dataCell", forIndexPath: indexPath) as! TableViewCell
        let _item = dataItems.items[indexPath.row]
        dataCell.title.text = _item.title
        dataCell.dateCreated.text = _item.createdDate
        return dataCell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            let _item = dataItems.items[indexPath.row]
            RESTcontroller.delete(_item.id, collectionURL: collectionURL, dataItems: self.dataItems)
        }
    }

}