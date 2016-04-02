//
//  BooksListTableViewController.swift
//  GoToBook
//
//  Created by Nurzhan Sagyndyk on 01.04.16.
//  Copyright © 2016 Nurzhan Sagyndyk. All rights reserved.
//

import UIKit
import Firebase

class BooksListTableViewController: UITableViewController {
    var items = [NSDictionary]()
    var detailViewController: DetailViewController? = nil
    var books = [Book]()
    var filteredBooks = [Book]()
    var firebase : Firebase!
    let searchController = UISearchController(searchResultsController: nil)
    var ref: Firebase!
    
    @IBAction func beginChat(sender: UIButton) {
        ref.authAnonymouslyWithCompletionBlock { (error, authData) in
            if error != nil { print(error.description); return }
            self.performSegueWithIdentifier("chat", sender: nil)
        }

    }
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Firebase(url: "https://gotobook.firebaseio.com")
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        books = [
            Book(category:"Popular", name:"Harry Potter"),
            Book(category:"Popular", name:"Lord"),
            Book(category:"Popular", name:"Dark Knight"),
            Book(category:"Newest", name:"Lollipop"),
            Book(category:"Newest", name:"Spiderman"),
            Book(category:"Newest", name:"Ronaldo"),
            Book(category:"Other", name:"iOS"),
            Book(category:"Other", name:"Hackathon"),
            Book(category:"Other", name:"Big Bear")]
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Other", "Popular", "Newest"]
        tableView.tableHeaderView = searchController.searchBar
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            
        }
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
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

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredBooks.count
        }
        return books.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let book: Book
        if searchController.active && searchController.searchBar.text != "" {
            book = filteredBooks[indexPath.row]
        } else {
            book = books[indexPath.row]
        }
        cell.textLabel!.text = book.name
        cell.detailTextLabel!.text = book.category
        return cell
    }
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let dict = items[indexPath.row]
        
        cell.textLabel?.text = dict["title"] as? String
    }
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredBooks = books.filter({( book  : Book) -> Bool in
            let categoryMatch = (scope == "All") || (book.category == scope)
            return categoryMatch && book.name.lowercaseString.containsString(searchText.lowercaseString)
        })
        tableView.reloadData()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let navVc = segue.destinationViewController as! UINavigationController
        let chatVc = navVc.viewControllers.first as! ChatViewController
        chatVc.senderId = ref.authData.uid
        chatVc.senderDisplayName = ""
    }
    
    
}

extension BooksListTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension BooksListTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
