//
//  Page2ViewController.swift
//  CyberNetwork Solutions
//
//  Created by Fakan Brandli on 8/18/16.
//  Copyright © 2016 Sabilopers. All rights reserved.
//

import Foundation
import UIKit


class Page2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var subTitleArray = [String]()
    let cellReuseIdentifier = "customCell2"
    var rootTitle: String = ""


    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subTitleArray = ["L700", "L1900", "MOD", "DIRECT", "Air 32", "L2100", "NSBC"]
        titleTxt.text = rootTitle
   
        
//        // Register the table view cell class and its reuse id
//        self.tableView.registerClass(CustomCell2.self, forCellReuseIdentifier: cellReuseIdentifier)
//
//        // This view controller itself will provide the delegate methods and row data for the table view.
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
        return 6
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let customCell : CustomCell2 = self.tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! CustomCell2
        customCell.txtName.text = subTitleArray[indexPath.row]
        return customCell
    }
    
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let menuVC = "page3"
        
        let viewController = storyboard?.instantiateViewControllerWithIdentifier(menuVC) as! Page3ViewController
        viewController.subTitle = subTitleArray[indexPath.row]
        viewController.rootTitle = rootTitle
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}