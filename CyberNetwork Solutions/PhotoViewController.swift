//
//  PhotoViewController.swift
//  CyberNetwork Solutions
//
//  Created by Wang Xiaoming on 8/17/16.
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

protocol GetImageDataDelegate {
    func getImageData(imgName:String, imgData:NSData)
}

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var titleTxt: UILabel!

    @IBOutlet weak var imagePicked: UIImageView?

    var getImageDataDelegate : GetImageDataDelegate?
    
    var titleStr: String = ""

    
    var imageFileName: String = ""
    var localPath: String = ""
    var folderName : String = ""
    
    var current: Int = 0
    
    var progressBarTimer:NSTimer!
    
    var alertView = UIAlertController()
    
    var service = GTLServiceDrive()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    
    @IBAction func btnOpenCameraPressed(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
   
    @IBAction func btnOpenGalleryPressed(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let newImage = ResizeImage(image, width: 355)
        imagePicked!.image = newImage
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
   
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func btnSavePressed(sender: AnyObject) {
        
        if self.imagePicked?.image != nil {
            let dfWithMilliSeconds = NSDateFormatter()
            imageFileName = String(format: "%d", dfWithMilliSeconds)
            imageFileName = imageFileName + ".jpg"
            
            let imgData: NSData = NSData(data: UIImageJPEGRepresentation((self.imagePicked!.image)!, 1)!)
            getImageDataDelegate!.getImageData(imageFileName,imgData: imgData)
            self.navigationController?.popViewControllerAnimated(true)
        } else{
             self.view.makeToast("There is not selected image", duration: 3.0, position: .Center)
        }
       
        
    }
    
    func ResizeImage(image: UIImage, width: CGFloat) -> UIImage {
        let size = image.size
        
        let widthRatio  = width / image.size.width
      
    
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        self.imageViewHeightConstraint.constant = size.height * widthRatio
       
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
}