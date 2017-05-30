//
//  ViewController.swift
//  CyberNetwork Solutions
//  Created by AHM. SAJID on 4/10/16.
//  Copyright © 2016 Sabilopers. All rights reserved.
//

import UIKit

struct ConstantArray {
    static var idDocsL700: NSArray = ["002", "052", "100"]
    static var nameDocsL700: NSArray = ["L700 Photo Log", "RBS Installation Checklist", "Call_Test_Results"]
    static var idPhotosL700: NSArray = ["001CM", "002CM", "003CM", "004CM", "005CM", "006CM", "007CM", "008CM", "009CM", "010CM", "011CM", "012CM", "013CM", "014CM", "015CM", "016CM", "017CM"]
    static var namePhotosL700: NSArray = ["Overall equipment area", "RBS 1 with door open", "AAV cabinet with door open", "SiteID_CI_Equipment to be removed", "Cable entry of RGS 1", "SiteID_CI_Cable entry of AAV cabinet", "GPS with cable connection", "Special Considerations/Potential Issues", "Issues", "Placard" , "SiteID_CI_Removed Equipment" , "Overall equipment area" , "AAV cabinet with door open", "Calbe entry of RBS", "Cable entry of AAV cabinet", "GPS with cable connection", "SiteID_Main Equipment"]
    
    static var idDocsL1900: NSArray = ["001", "002", "003", "004", "004A", "007"]
    static var nameDocsL1900: NSArray = ["L1900 COP Checklist" , "L1900 Photo Log", "L1900 LMU-Mechanical Fact Sheet", "L1900 GPS Migration Form", "Call Test Results", "L1900 TMO Asset Data Collection"]
    static var idPhotosL1900: NSArray = ["009", "010", "011", "012", "013", "014", "015"]
    static var namePhotosL1900: NSArray = ["Post Photo 9 Over all equipment area", " Post Photo 10 RBS 1 with door open", "Post Photo 11 Electrical panel with door open", "Post Photo 12 Cable Entry of RBS 1", "Post Photo 13 Battery Cabinet", " Post Photo 14 Battery Vent Tubing", "Post Photo 15 GPS with cable Connection"]
    
    static var idDocsAir32: NSArray = ["001A", "006", "007", "008", "010a", "016", "017", "018", "023", "026", "027"]
    static var nameDocsAire32: NSArray = ["Pre Construction Photo Checklist", "Asset Tracking Form (Make, Model, Serial number)", "Redline As-Built Construction Drawings (pdf format)", "BOM (Bill of Material)", " Post Construction Photo Checklist", "Initial T-Mobile Punchwalk Defect Photos", "Final T-Mobile Outstanding Issues List, Defect Photos", "SP Site Completion Letter (NOCC)", "Shipping Documents", "RBS Installation Quality Checklist", " Pre-Installation Fiber Test Data"]
    static var idPhotosAir32:NSArray = ["001", "002", "003", "003a", "003b", "003c", "014", "015", "053", "053a", "053b", "053b", "053c", "054", "056", "057", "057a", "058", "059", "060", "061"]
    static var namePhotosAir32: NSArray = ["Pre_Placard","Pre_Overall Site", "Pre_Overall equipment area", "Pre_Cabine", "Pre_Power H Frame", "Pre_Power Subrack", "Pre_Issues", "Post_Placard", "Post_Hybrid Jmprs", "Meter to PPC", "AC Pwr Brkr", "Disconct Pnl Brkr", "Post_DC Cabling", "Post_RBS", "Post_RBS Brkr Labels", "Cabinet(s)", "Post_Hdw to Rtrn", "Post_Acess Rd PC", "Post_Cmpnd", "Post_DC Conn - Brkr"]
    
}

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var menuArray = [String]()
    
    
    var viewControllerIdtentiy = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
       
        
        menuArray = ["T-Mobile",
                     "AT&T",
                     "Sprint",
                     "Verizon"]
        
        viewControllerIdtentiy = ["page2",
                                  "atntPage",
                                  "sprintPage",
                                  "verizonPage"]
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        let tmobileNib = UINib(nibName: "CustomCell", bundle: nil)
//        tableView.registerNib(tmobileNib, forCellReuseIdentifier: "tmobile")
//        
//        let atntNib = UINib(nibName: "CustomCell", bundle: nil)
//        tableView.registerNib(atntNib, forCellReuseIdentifier: "atnt")
//        
//        let sprintNib = UINib(nibName: "CustomCell", bundle: nil)
//        tableView.registerNib(sprintNib, forCellReuseIdentifier: "sprint")
//        
//        let verizonNib = UINib(nibName: "CustomCell", bundle: nil)
//        tableView.registerNib(verizonNib, forCellReuseIdentifier: "verizon")
//        
}

    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: CustomCell!
        
        if indexPath.row == 0 {
            
            cell = self.tableView.dequeueReusableCellWithIdentifier("tmobile", forIndexPath: indexPath) as! CustomCell
            cell.tmobilecell.text = menuArray[0]
            
        } else if indexPath.row == 1 {
            
            cell = self.tableView.dequeueReusableCellWithIdentifier("atnt", forIndexPath: indexPath) as! CustomCell
            cell.atntcell.text = menuArray[1]
            
        } else if indexPath.row == 2 {
            
            cell = self.tableView.dequeueReusableCellWithIdentifier("sprint", forIndexPath: indexPath) as! CustomCell
            cell.sprintcell.text = menuArray[2]
            
        } else if indexPath.row == 3 {
            
            cell = self.tableView.dequeueReusableCellWithIdentifier("verizon", forIndexPath: indexPath) as! CustomCell
            cell.verizoncell.text = menuArray[3]
            
        }
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let menuVC = viewControllerIdtentiy[0]
        
        let viewController: Page2ViewController = storyboard?.instantiateViewControllerWithIdentifier(menuVC) as! Page2ViewController
        viewController.rootTitle = menuArray[indexPath.row]
        viewController.rootTitle = menuArray[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

