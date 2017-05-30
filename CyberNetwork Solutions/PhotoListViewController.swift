//
//  PhotoListViewController.swift
//  Senjin Rana
//
//  Created by Fakan Brandli on 8/27/16.
//  Copyright © 2016 Sabilopers. All rights reserved.
//


import UIKit
import SwiftyDropbox
import Foundation
import DLRadioButton
import GoogleAPIClient
import GTMOAuth2
import xlsxwriter
import Toast_Swift


class PhotoListViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, GetImageDataDelegate{
    
    var photoArray = [String]()
    var cellReuseIdentifier: String = "customCell4"
    
    var rootTitle : String = ""
    var subTitle : String = ""
    var folderName : String = ""
    var imageData : NSData?
    var imageDataIndex : Int?
    
    var imageList:Dictionary<String, NSData> = [:]
    var imageNameList:Dictionary<String, String> = [:]
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if subTitle == "L700" {
            
             photoArray = ConstantArray.namePhotosL700 as! [String]
            
        } else if subTitle == "L1900" {
            
             photoArray = ConstantArray.namePhotosL1900 as! [String]
            
        } else if subTitle == "Air 32" {
            
            photoArray = ConstantArray.namePhotosAir32 as! [String]
        } else {
            
        }
        
        if photoArray.count != 0 {
            
            tableView.delegate = self
            tableView.dataSource = self
            
            titleTxt.text = folderName + " Photo"
        }
        
      
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func getImageData(imgName:String, imgData: NSData) {
        imageNameList[photoArray[self.imageDataIndex!]] = imgName
        imageList[imgName] = imgData
    }


    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let customCell : CustomCell4 = self.tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! CustomCell4
        customCell.imageName.text = photoArray[indexPath.row]
        return customCell
    }
    
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let menuVC = "photoPage"
        self.imageDataIndex = indexPath.row
        let viewController = storyboard?.instantiateViewControllerWithIdentifier(menuVC) as! PhotoViewController
        viewController.titleStr = photoArray[indexPath.row]
        viewController.getImageDataDelegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func btnNextPagePressed(sender: AnyObject) {
        
        if photoArray.count != 0 {
            let menuVC = "page4"
            
            let viewController = storyboard?.instantiateViewControllerWithIdentifier(menuVC) as! L702Ccpage5
            viewController.subTitle = self.subTitle
            viewController.folderName = self.folderName
            viewController.imageList = self.imageList
            viewController.imageNameList = self.imageNameList
            viewController.rootTitle = self.rootTitle
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            self.view.makeToast("There is not the data", duration: 3.0, position: .Center)

        }
       
    }
    
    
    @IBAction func btnBackPressed(sender: AnyObject) {
        
        self.navigationController!.popViewControllerAnimated(true)
        
    }
    
}