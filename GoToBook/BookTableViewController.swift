//
//  BookTableViewController.swift
//  GoToBook
//
//  Created by Nurzhan Sagyndyk on 02.04.16.
//  Copyright © 2016 Nurzhan Sagyndyk. All rights reserved.
//

import UIKit
import Firebase
class BookTableViewController: UITableViewController {
    var firebase : Firebase!
    var items = [NSDictionary]()
    var currentUsername = LoginViewController.loginCaption
    
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let dict = items[indexPath.row]
        
        cell.textLabel?.text = dict["title"] as? String
        
        let base64String = dict["photoBase64"] as! String
        populateImage(cell, imageString: base64String)
    }
    
    func populateImage(cell:UITableViewCell, imageString: String) {
        
        let decodedData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        
        let decodedImage = UIImage(data: decodedData!)
        
        cell.imageView!.image = decodedImage
        
    }
    
    func loadDataFromFirebase() {
        firebase = Firebase(url: "https://gotobook.firebaseio.com/books")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        firebase.ref.observeEventType(.Value, withBlock: { snapshot in
            var tempItems = [NSDictionary]()
            
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                let dict = child.value as! NSDictionary
                tempItems.append(dict)
            }
            
            self.items = tempItems
            self.tableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        })
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        items = [NSDictionary]()
        
        loadDataFromFirebase()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("bookCell", forIndexPath: indexPath)
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let dict = items[indexPath.row]
            let name = dict["name"] as! String
            
            // delete data from firebase
            
            let profile = firebase.ref.childByAppendingPath(name)
            profile.removeValue()
        }
    }
    
    @IBAction func SearchControl(sender: UIButton) {
        self.performSegueWithIdentifier("searchBook", sender: nil)
    }
        @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? BookAddViewController {
            // Add a new meal.
            let newIndexPath = NSIndexPath(forRow: items.count, inSection: 0)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
    }


}
