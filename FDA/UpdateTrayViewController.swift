//
//  UpdateTrayViewController.swift
//  FDA
//
//  Created by Mahendar on 8/5/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import UIKit
import CoreData

class UpdateTrayViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate {
    var trayNumber : Int = 0
    @IBOutlet var imageView: UIImageView!
    var dicForsaveTrays :[String: Any] = [:]
    var tray:TrayAssembly! = nil
    var trayArr:[[String: Any]] = [[:]]
    var isFromBackButton:Bool = false
    
    let imagePicker = UIImagePickerController.init()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //tray = CommanMethods.fetchData(trayId: dicForsaveTrays["trayId"] as! String,dicForsaveTrays: dicForsaveTrays, imageView: imageView)
        
        /*------------------------------------------------------
         For testing purpose we are using the photoLibrary
         ------------------------------------------------------*/
        
        imagePicker.delegate = self
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
     /*------------------------------------------------------
     The below methdo will get user back to goToTrayVC
     ------------------------------------------------------*/
    
    @IBAction func btnBackAction(_ sender: Any)
    {
        isFromBackButton = true
        self.performSegue(withIdentifier: Constants.kUnwindToGotoTray, sender: nil)
    }
    
    /*------------------------------------------------------
     The below methdo will get user back to goToTrayVC by saving updated image for pre surgery
     ------------------------------------------------------*/
    
    @IBAction func saveTray(sender : UIButton)
    {
        if #available(iOS 10.0, *)
        {
            /*------------------------------------------------------
             here we are checking that if the same id tray is stord in our database or not
             ------------------------------------------------------*/
            
            if(tray == nil)
            {
                tray = NSEntityDescription.insertNewObject(forEntityName: Constants.kTrayAssembly, into: Constants.appDelegate.persistentContainer.viewContext) as! TrayAssembly
                tray.trayId = dicForsaveTrays[Constants.kstrtrayId] as? String
            }
            
        }
        else
        {
            /*------------------------------------------------------
             Fallback on earlier versions
             ------------------------------------------------------*/
        }
        
        if(imageView.image != nil)
        {
            //tray.image = UIImagePNGRepresentation(imageView.image!)! as NSData
            
            let value = (dicForsaveTrays[Constants.kstrtrayId]! as! [Int])[trayNumber-1]
            
            let urlString =  Constants.updatepreimagebyassemblyid + "/\(value)"
            
            CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
            
            updateTrayPictureWebservice().postTrayImage([:], urlString, imageView.image!, { (response, err) in
                
                CommanMethods.removeProgrssView(isActivity: true)
                let actionsheet = UIAlertController.init(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                var okButton:UIAlertAction! = nil
                
                if let msg:String = response?[Constants.kstrmessage] as? String
                {
                    if(msg == Constants.kstrFailed)
                    {
                        CommanMethods.removeProgrssView(isActivity: true)
                        CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
//                        self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                        return
                    }
                }
                
                if response != nil
                {
                    actionsheet.message = Constants.kAlert_Image_updated
                    okButton = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        
                        
                        self.performSegue(withIdentifier: Constants.kUnwindToGotoTray, sender: nil)
                        
                    })
                }
                else
                {
                    actionsheet.message = Constants.kstrWrongResponse
                    okButton = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        self.performSegue(withIdentifier: Constants.kUnwindToGotoTray, sender: nil)
                    })
                }
                
                actionsheet.addAction(okButton)
                
                DispatchQueue.main.async
                {
                    self.present(actionsheet, animated: true, completion: nil)
                }
            })
        }
        
        if #available(iOS 10.0, *)
        {
            do
            {
                try Constants.appDelegate.persistentContainer.viewContext.save()
            }
            catch let error
            {
                print(error)
            }
            
        }
        else
        {
            // Fallback on earlier versions
        }
        
        if(imageView.image == nil)
        {
            self.performSegue(withIdentifier: Constants.kUnwindToGotoTray, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(isFromBackButton == true)
        {
            return
        }
        
        if let viewController = segue.destination as? GoToTrayViewController
        {
            if(imageView.image != nil)
            {
                viewController.imageView.image = imageView.image
            }
        }
        if let viewController = segue.destination as? ScanBarcodePreSurgeryViewController
        {
            if(imageView.image != nil)
            {
                viewController.imageView.image = imageView.image
            }
        }
    }
    
    @IBAction func actionTakeImage(_ sender: Any)
    {
        let btn = sender as! UIButton
        
        let actionsheet = UIAlertController.init(title: "", message: Constants.kAlert_Select_Image, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraButton = UIAlertAction(title: Constants.kCamera, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            self.imagePicker.delegate = self
            
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                
                DispatchQueue.main.async
                {
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
                
            }
            else
            {
                let alertVC = UIAlertController(
                    title: Constants.kAlert_No_Camera,
                    message: Constants.kAlert_Sorry_this_device_has_no_camera,
                    preferredStyle: .alert)
                let okAction = UIAlertAction(
                    title: "OK",
                    style:.default,
                    handler: nil)
                alertVC.addAction(okAction)
                
                DispatchQueue.main.async
                {
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        })
        
        let gallaryButton = UIAlertAction(title: Constants.kAlert_Choose_from_Gallery, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.imagePicker.modalPresentationStyle = .popover
            
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
            {
                let popOver = self.imagePicker.popoverPresentationController
                popOver?.sourceView = btn
                popOver?.sourceRect = btn.bounds
                popOver?.permittedArrowDirections = .any
                
                
                self.present(self.imagePicker, animated: true, completion:
                {
                    
                })
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }

        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        
        actionsheet.addAction(cameraButton)
        actionsheet.addAction(gallaryButton)
        actionsheet.addAction(cancelButton)
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
        {
            
            let popOver = actionsheet.popoverPresentationController
            popOver?.sourceView = btn
            popOver?.sourceRect = btn.bounds
            popOver?.permittedArrowDirections = .any
            
            self.present(actionsheet, animated: true, completion:
            {
                
            })
        }
        else
        {
            DispatchQueue.main.async
            {
                self.present(actionsheet, animated: true, completion: nil)
            }
        }
        
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
//        {
//            self.present(imagePicker, animated: true, completion: nil)
//        }
    }
    
    @IBAction func actionRetakePicture(_ sender: Any)
    {
        
        self.actionTakeImage(sender)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image

        let strUserID =  UserDefaults.standard.value(forKey: Constants.kUserID)
        let trayId = dicForsaveTrays[Constants.kstrtrayId]
        
        let dictionaryTray = ["TrayImage": UIImagePNGRepresentation(image),"UserId":strUserID,Constants.kstrtrayId:trayId]
        
        dicForsaveTrays["Trays"] = ["PreSurgery":[]]
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openMenu(_ sender: UIButton)
    {
        CommanMethods.openSideMenu(navigationController: navigationController!)
    }
}
