//
//  Page3ViewController.swift
//  CyberNetwork Solutions
//
//  Created by Fakan Brandli on 8/19/16.
//  Copyright © 2016 Sabilopers. All rights reserved.
//

import Foundation
import UIKit


class Page3ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var folderNameArray = [String]()
    let cellReuseIdentifier = "customCell3"
    var subTitle: String = ""
    var rootTitle: String = ""
    
    var existImage : Bool = false
    
    
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTxt.text = rootTitle + " " + subTitle
        
        
        folderNameArray = ["702Cc", "702Cu", "703Bu", "704Au", "704E", "704G", "704Gu"]
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func btnBackPressed(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let customCell : CustomCell3 = self.tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! CustomCell3
        customCell.nameTxt.text = folderNameArray[indexPath.row]
        return customCell
    }
    
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let menuVC = "photoList"
        
        let viewController = storyboard?.instantiateViewControllerWithIdentifier(menuVC) as! PhotoListViewController
        viewController.subTitle = subTitle
        viewController.rootTitle = self.rootTitle
        viewController.folderName = self.folderNameArray[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}
