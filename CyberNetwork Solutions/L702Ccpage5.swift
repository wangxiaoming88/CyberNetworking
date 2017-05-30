//
//  L702Ccpage5.swift
//  CyberNetwork Solutions
//
//  Created by Wang Xiaoming on 4/15/16.
//  Copyright © 2016 Sabilopers. All rights reserved.
//

import UIKit
import SwiftyDropbox
import GoogleAPIClient
import GTMOAuth2
import xlsxwriter


class L702Ccpage5: UIViewController,UIScrollViewDelegate ,  UITableViewDelegate, UITableViewDataSource{
    
    let RBS = "RBS Installation Checklist"
    let Call = "Call_Test_Results"
    
    var previewArray = [String]()
    
    var docArray:NSArray?
    var idPhotos = [String]()
    var docValues = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    
    var imageList:Dictionary<String,NSData> = [:]
    var imageNameList:Dictionary<String,String> = [:]
    var names:NSArray?
    var idDocs = [String]()
    
    var subTitle: String = ""
    var folderName: String = ""
    var rootTitle: String = ""
    var prefix: String = ""
    var prefixPL: String = ""
    
    var docFileName: String = ""
    var dateStr: String = ""
    var writePath : String = ""
    
    var globalWorkBook = new_workbook("")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
        
        titleTxt.text = subTitle + " Excel"
        
        if rootTitle == "T-Mobile" {
            rootTitle = "TMO"
        }
        prefix = rootTitle + subTitle
        prefixPL = rootTitle + "P" + subTitle
        
        tableView.reloadData()
        
    }
    
    func initialize(){
        
        if subTitle == "L700" {
            
            docArray = ConstantArray.nameDocsL700 as! [String]
            names = ConstantArray.namePhotosL700 as! [String]
            idPhotos = ConstantArray.idPhotosL700 as! [String]
            idDocs = ConstantArray.idDocsL700 as! [String]
            
        } else if subTitle == "L1900" {
            
            docArray = ConstantArray.nameDocsL1900 as! [String]
            names = ConstantArray.namePhotosL1900 as! [String]
            idPhotos = ConstantArray.idPhotosL1900 as! [String]
            idDocs = ConstantArray.idDocsL1900 as! [String]
            
        } else if subTitle == "Air 32" {
            
            docArray = ConstantArray.nameDocsAire32 as! [String]
            names = ConstantArray.namePhotosAir32 as! [String]
            idPhotos = ConstantArray.idPhotosAir32 as! [String]
            idDocs = ConstantArray.idDocsAir32 as! [String]
        }

    }
    // When the view appears, ensure that the Drive API service is authorized
    // and perform API calls
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docArray!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let customCell : CustomCell5 = self.tableView.dequeueReusableCellWithIdentifier("customCell5", forIndexPath: indexPath) as! CustomCell5
        customCell.nameTxt.text = docArray![indexPath.row] as! String
        return customCell
    }
    

    @IBAction func btnBackpressed(sender: AnyObject) {
         self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    func writeXlsxToDocument(){
        
       
        
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        writePath = documents.stringByAppendingString("/tutorial01.xlsx")
        print(writePath)
//        writePath = "tutorial01.xlsx"
        let workbook = new_workbook(writePath)
        globalWorkBook = workbook
        
        // Add a worksheet with a user defined sheet name.
        let worksheet1 = workbook_add_worksheet(workbook, "Sheet1")
        

        // Widen the first column to make the text clearer.
        worksheet_set_column(worksheet1, 0, 0, 100, nil)
        
        // Write doc part
        
        var i:Int = 0
        for item in docArray!{
            
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            var cell = tableView.cellForRowAtIndexPath(indexPath) as! CustomCell5
            let name: String = cell.txtInputName.text!
            let row = i
        
            if name == "" {
                worksheet_write_string(worksheet1, UInt32(row), 0, prefix + "-" + idDocs[i] +  " " + (item as! String), nil)
                let previewElement = prefix + "-" + idDocs[i] +  " " + (item as! String)
                previewArray.append(previewElement)
            } else {
                worksheet_write_string(worksheet1, UInt32(row), 0, prefix + "-" + idDocs[i] +  " " + (item as! String) + "-" + name, nil)
                let previewElement = prefix + "-" + idDocs[i] +  " " + (item as! String) + "-" + name
                previewArray.append(previewElement)
            }
            
            i = i + 1
        }
        
       
        // write the photo part
        var index: Int = 0
        for item in names!{
            
            let name = item
            let row = index + docArray!.count
            
            var imageName = ""
            
            for item2 in imageNameList {
                if item as! String == item2.0 {
                    imageName = item2.1
                }
            }
            
            if imageName == "" {
                worksheet_write_string(worksheet1, UInt32(row), 0, prefixPL + "-" + idPhotos[index] +  " " + (name as! String), nil)
                let previewElement = prefixPL + "-" + idPhotos[index] +  " " + (name as! String)
                previewArray.append(previewElement)
            } else {
                worksheet_write_string(worksheet1, UInt32(row), 0, prefixPL + "-" + idPhotos[index] +  " " + (name as! String) + "-" + imageName, nil)
                let previewElement = prefixPL + "-" + idPhotos[index] +  " " + (name as! String) + "-" + imageName
                previewArray.append(previewElement)

                
            }
            
            index = index + 1

        }
    
        
        // Close the workbook, save the file and free any memory
        workbook_close(workbook)

    }
    
    
    @IBAction func btnPreviewPressed(sender: AnyObject) {
        
        writeXlsxToDocument()
        
        let menuVC = "submitPage"
        
        let viewController = storyboard?.instantiateViewControllerWithIdentifier(menuVC) as! PreviewViewController
        viewController.folderName = self.folderName
        viewController.excelFilePath = self.writePath
        viewController.imageList = self.imageList
        viewController.previewArray = self.previewArray
        self.navigationController?.pushViewController(viewController, animated: true)

        
    }
}
