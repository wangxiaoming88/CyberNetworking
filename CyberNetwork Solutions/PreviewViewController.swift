//
//  PreviewViewController.swift
//  Senjin Rana
//
//  Created by Anton Ivanov on 8/27/16.
//  Copyright © 2016 Sabilopers. All rights reserved.
//

import UIKit
import DLRadioButton
import SwiftyDropbox
import GoogleAPIClient
import GTMOAuth2


class PreviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    @IBOutlet weak var progressBar: UIProgressView!
//    @IBOutlet weak var progressTxt: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var RDDropbox: DLRadioButton!
    @IBOutlet weak var RDGoogleDrive: DLRadioButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressTxt: UILabel!

    @IBOutlet weak var totalProgressgTxt: UILabel!
    @IBOutlet weak var totalProgressbar: UIProgressView!
    
    var imageList:Dictionary<String,NSData> = [:]
    
    var previewArray = [String]()
    
    var imageFileName: String = ""
    var localPath: String = ""
    var folderName : String = ""
    var excelFilePath : String = ""
    var rootTitle : String = ""

    
    private let kKeychainItemName = "Drive API"
    private let kClientID = "573986124525-ipi3jmhffs9bgtvjl4fo7ao0aq8q6k95.apps.googleusercontent.com"
    
    private let scopes = [kGTLAuthScopeDriveFile]
    private let service = GTLServiceDrive()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalProgressbar.setProgress(0, animated: false)
        progressBar.setProgress(0, animated: false)
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previewArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:previewCell = self.tableView.dequeueReusableCellWithIdentifier("previewCell")! as! previewCell
        cell.name.text = previewArray[indexPath.row]
        return cell
        
    }

    
    // Creates the auth controller for authorizing access to Drive API
    private func createAuthController() -> GTMOAuth2ViewControllerTouch {
        
        let scopeString = scopes.joinWithSeparator(" ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: "viewController:finishedWithAuth:error:"
        )
    }
    
    // Handle completion of the authorization process, and update the Drive API
    // with the new credentials.
    func viewController(vc : UIViewController,
                        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        
        if let error = error {
            service.authorizer = nil
            showAlert("Authentication Error", message: error.localizedDescription)
            return
        }
        
        service.authorizer = authResult
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.Default,
            handler: nil
        )
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }

    
    @IBAction func btnSubmitPressed(sender: AnyObject) {
        
        totalProgressbar.setProgress(0, animated: false)
        totalProgressgTxt.text = ""
        
        progressBar.setProgress(0, animated: false)
        progressTxt.text = ""
        
        if (RDDropbox.selected == true) {
            uploadExcelToDropbox()
            uploadToDropbox()
        }
        
        if (RDGoogleDrive.selected == true) {
            uploadExcelToGoogleDrive()
            uploadToGoogleDrive()
        }

    }
    
    func uploadToDropbox() {
        uploadItemToDropbox(0)
        
    }
    
    func uploadToGoogleDrive(){
        uploadItemToGoogleDrive(0)
    }

    func uploadItemToDropbox(intIndex: Int){
        
        if let client = Dropbox.authorizedClient {
            
            var bufImageData : NSData?
            
            // loop uploading for image list.
            //        for (key, value) in self.imageList {
            
            progressBar.setProgress(0, animated: false)
            progressTxt.text = ""
            
            let index = imageList.startIndex.advancedBy(intIndex) // index 1
            bufImageData = imageList.values[index]
            imageFileName = imageList.keys[index]
            
            
            //            let fileData = imgData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            client.files.upload(path: "/" + folderName + "/"+imageFileName, body: bufImageData!)
                .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                    
                    print("bytesRead: \(bytesRead)")
                    print("totalBytesRead: \(totalBytesRead)")
                    print("totalBytesExpectedToRead: \(totalBytesExpectedToRead)")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        let fractionalProgress = Float(totalBytesRead)/Float(totalBytesExpectedToRead)
                        let fractionalProgressStr = String(format: "%.2f", fractionalProgress)
                        let twoDecimalFractionalProgress = Float(fractionalProgressStr as String)
                        
                        print("fractionalProgress: \(twoDecimalFractionalProgress)")
                        
                        self.progressBar.setProgress(twoDecimalFractionalProgress!, animated: true)
                        
                        let progressInt = Int(twoDecimalFractionalProgress! * 100)
                        self.progressTxt.text =  String(progressInt) + " %"
                        
                        
                    }
                    
                }
                
                .response { response, error in
                    if let metadata = response {
                        print("*** Upload file ****")
                        print("Uploaded file name: \(metadata.name)")
                        print("Uploaded file revision: \(metadata.rev)")
                        
                        if(intIndex < self.imageList.count-1){
                            self.uploadItemToDropbox(intIndex + 1)
                        }
                        
                        let fractionalProgress = Float(intIndex+1)/Float(self.imageList.count)
                        let fractionalProgressStr = String(format: "%.2f", fractionalProgress)
                        let twoDecimalFractionalProgress = Float(fractionalProgressStr as String)
                        
                        
                        self.totalProgressbar.setProgress(Float(intIndex+1)/Float(self.imageList.count), animated: true)
                        
                        let progressInt = Int(twoDecimalFractionalProgress! * 100)
                        self.totalProgressgTxt.text = String(progressInt) + " %"
                        
                        
                        
                        //                            // Get file (or folder) metadata
                        //                            client.files.getMetadata(path: self.localPath).response { response, error in
                        //                                print("*** Get file metadata ***")
                        //                                if let metadata = response {
                        //                                    if let file = metadata as? Files.FileMetadata {
                        //                                        print("This is a file with path: \(file.pathLower)")
                        //                                        print("File size: \(file.size)")
                        //                                    } else if let folder = metadata as? Files.FolderMetadata {
                        //                                        print("This is a folder with path: \(folder.pathLower)")
                        //                                    }
                        //                                } else {
                        //                                    print(error!)
                        //                                }
                        //                            }
                        
                        
                    } else {
                        print(error!)
                    }
            }
        }
        
    }
    
    func uploadItemToGoogleDrive(intIndex: Int){
        
        
        var bufImageData : NSData?
        
        // loop uploading for image list.
        //        for (key, value) in self.imageList {
        
        progressBar.setProgress(0, animated: false)
        progressTxt.text = ""
        
        let index = imageList.startIndex.advancedBy(intIndex) // index 1
        bufImageData = imageList.values[index]
        imageFileName = imageList.keys[index]
        
        let title = imageFileName
        let mimeType = "image/jpeg"
        let metaData = GTLDriveFile()
        metaData.name = title
        let uP = GTLUploadParameters(data: bufImageData!, MIMEType: mimeType)
        let query = GTLQueryDrive.queryForFilesCreateWithObject(metaData, uploadParameters: uP)
        
        let serviceTicket = service.executeQuery(query, completionHandler: {(ticket, file, error) -> Void in
            
            if(intIndex < self.imageList.count-1){
                self.uploadItemToGoogleDrive(intIndex + 1)
            }
            
            let fractionalProgress = Float(intIndex+1)/Float(self.imageList.count)
            let fractionalProgressStr = String(format: "%.2f", fractionalProgress)
            let twoDecimalFractionalProgress = Float(fractionalProgressStr as String)
            
            
            self.totalProgressbar.setProgress(Float(intIndex+1)/Float(self.imageList.count), animated: true)
            
            let progressInt = Int(twoDecimalFractionalProgress! * 100)
            self.totalProgressgTxt.text = String(progressInt) + " %"
            
            
        })
        
        serviceTicket.uploadProgressBlock = {(ticket, written, total) in
            
            print("making progress")
            
            print(written.hashValue)
            print(total.hashValue)
            
            dispatch_async(dispatch_get_main_queue()) {
                let fractionalProgress = Float(written.hashValue)/Float(total.hashValue)
                let fractionalProgressStr = String(format: "%.2f", fractionalProgress)
                let twoDecimalFractionalProgress = Float(fractionalProgressStr as String)
                
                print("fractionalProgress: \(twoDecimalFractionalProgress)")
                
                self.progressBar.setProgress(twoDecimalFractionalProgress!, animated: true)
                
                let progressInt = Int(twoDecimalFractionalProgress! * 100)
                self.progressTxt.text =  String(progressInt) + " %"
                
            }
        }
    }

    
    @IBAction func RDDropboxPressed(sender: AnyObject) {
        
        totalProgressbar.setProgress(0, animated: false)
        totalProgressgTxt.text = ""
        
        progressBar.setProgress(0, animated: false)
        progressTxt.text = ""
       
        RDGoogleDrive.selected = false
        
//        Dropbox.unlinkClient() // clean authentication
        
        // Verify user is logged into Dropbox
        if let client = Dropbox.authorizedClient {
            
            // Get the current user's account info
            client.users.getCurrentAccount().response { response, error in
                print("*** Get current account ***")
                if let account = response {
                    print("Hello \(account.name.givenName)!")
                } else {
                    print(error!)
                }
            }
            
            // List folder
            client.files.listFolder(path: "").response { response, error in
                print("*** List folder ***")
                if let result = response {
                    print("Folder contents:")
                    for entry in result.entries {
                        print(entry.name)
                    }
                } else {
                    print(error!)
                }
            }
            
            
        } else{
            Dropbox.authorizeFromController(self)
        }
    }
    
    @IBAction func RDGoogleDrivePressed(sender: AnyObject) {
        
        totalProgressbar.setProgress(0, animated: false)
        totalProgressgTxt.text = ""
        
        progressBar.setProgress(0, animated: false)
        progressTxt.text = ""
        
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }
        
        RDDropbox.selected = false
        
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth {
            //            fetchFiles()
           
        } else {
            presentViewController(
                createAuthController(),
                animated: true,
                completion: nil
            )
        }
    }
    
    @IBAction func btnBackPressed(sender: AnyObject) {
        
        self.navigationController!.popViewControllerAnimated(true)
    }
    
     func uploadExcelToGoogleDrive(){
        
        let destinationPath = excelFilePath
        let filemgr = NSFileManager.defaultManager()
        let data = filemgr.contentsAtPath(excelFilePath)
        if filemgr.fileExistsAtPath(destinationPath) {
            print("File exists")
            
        } else {
            print("File does not exist")
        }

        
        let title = "Hello-x-excel.xlsx"
        //        let content = "hello world"
        let  mimeType = "aapplication/x-excel"
        let metaData = GTLDriveFile()
        metaData.name = title
        //        let data = readdata.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let uP = GTLUploadParameters(data: data!, MIMEType: mimeType)
        let query = GTLQueryDrive.queryForFilesCreateWithObject(metaData, uploadParameters: uP)
        
        let serviceTicket = service.executeQuery(query, completionHandler: {(ticket, file, error) -> Void in
            
            print("complete")
            
            
        })
        
        serviceTicket.uploadProgressBlock = {(ticket, written, total) in
            
            print("making progress")
            
        }

    }
    
    func uploadExcelToDropbox() {
        
        if let client = Dropbox.authorizedClient {
            
            let destinationPath = excelFilePath
            let filemgr = NSFileManager.defaultManager()
            let data = filemgr.contentsAtPath(excelFilePath)
            if filemgr.fileExistsAtPath(destinationPath) {
                print("File exists")
                
            } else {
                print("File does not exist")
            }
            
            
            let title = "Hello-x-excel.xlsx"
            let  mimeType = "aapplication/x-excel"
            
            
            //            let fileData = imgData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            client.files.upload(path: "/" + folderName + "/"+title, body: data!)
                .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                    
                    print("bytesRead: \(bytesRead)")
                    print("totalBytesRead: \(totalBytesRead)")
                    print("totalBytesExpectedToRead: \(totalBytesExpectedToRead)")
                    
                }
                
                .response { response, error in
                    if let metadata = response {
                        print("*** Upload file ****")
                        print("Uploaded file name: \(metadata.name)")
                        print("Uploaded file revision: \(metadata.rev)")
                        
                        
                    } else {
                        print(error!)
                    }
            }
        }

        
    }
}


