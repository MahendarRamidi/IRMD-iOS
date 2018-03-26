//
//  PresurgeryAcceptAndTakePictureViewController.swift
//  FDA
//  Purpose :- This class is being initiated from SelectImplantPreSurgeryViewController and SelectImplantPreSurgeryTray2ViewController
//  Created by Cygnet Infotech on 16/11/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit
import MobileCoreServices

class PresurgeryAcceptAndTakePictureViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,CustomAlertDelegate
{
    var alertView = CustomAlertViewController.init()
    var strBaseClass = ""
    var caseId:Any! = nil
    var trayNumber : Int = 0
    var trayType : NSString = ""
    var imageData = NSData()
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    let imagePicker = UIImagePickerController.init()
    var assemblyID : NSString = ""
    @IBOutlet weak var imageView: UIImageView!
    var dicForsaveTrays :[String: Any] = [:]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        /*------------------------------------------------------
         Below code if for preparing alert view for presenting as alert box and setting the delegate as current class. that will be helpful in calling the action of okbutton when user taps on ok button in alert view
         ------------------------------------------------------*/
        alertView = self.storyboard?.instantiateViewController(withIdentifier: Constants.kCustomAlertViewController) as! CustomAlertViewController
        
        alertView.delegate = self
        /*------------------------------------------------------*/
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationItem.hidesBackButton = true;
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    /*------------------------------------------------------
     The below if the action call of the button of alertView that is customis a delegate method of CustomAlertDelegate. The alertview is same but the actions are different that is being set while calling the alertView custom
     ------------------------------------------------------*/
    func okBtnAction()
    {
        /*------------------------------------------------------
         the current value of assembly id is being cloned and a new id is being assigned to cloned tray so the further calculation and flow will be driven by new assembly id that is being generated from class SelectImplantPreSurgeryViewController and SelectImplantPreSurgeryTray2ViewController api createpreassemblyclone response
         ------------------------------------------------------*/
        
        //(self.dicForsaveTrays["trayId"]! as! [Int])[] = [value!]
        
        var test = (self.dicForsaveTrays[Constants.kstrtrayId] as! [Any])
        
        test[self.trayNumber-1] = Int(self.assemblyID as String)!
        
        self.dicForsaveTrays[Constants.kstrtrayId]  = test
        
        /*------------------------------------------------------
         this code unwind the segue to either ScanBarcodePreSurgeryViewController or GoToTrayVC
         ------------------------------------------------------*/
        
        if(self.strBaseClass == Constants.kScanBarcodePreSurgeryViewController)
        {
            self.performSegue(withIdentifier: Constants.kunwindToGoToScanBarCodePreSurgeryWithSegue, sender: nil)
        }
        else
        {
            self.performSegue(withIdentifier: Constants.kGoToTray, sender: nil)
        }
        
    }
    
    /*------------------------------------------------------
     below method will be adding camera view to current VC
     ------------------------------------------------------*/    
    @IBAction func btnTakePicture(_ sender: Any)
    {
        let btn = sender as! UIButton
        
        let actionsheet = UIAlertController.init(title: "", message: Constants.kAlert_Select_Image, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraButton = UIAlertAction(title: Constants.kCamera, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            self.imagePicker.delegate = self
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.allowsEditing = false
                
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.mediaTypes = [kUTTypeImage as String]
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                
                DispatchQueue.main.async {
                    
                    self.present(self.imagePicker, animated: true, completion: nil)
                    
                }
                
            } else {
                
                let alertVC = UIAlertController(
                    title: Constants.kAlert_No_Camera,
                    message: Constants.kAlert_Sorry_this_device_has_no_camera,
                    preferredStyle: .alert)
                let okAction = UIAlertAction(
                    title: "OK",
                    style:.default,
                    handler: nil)
                alertVC.addAction(okAction)
                
                DispatchQueue.main.async {
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
                
                self.present(self.imagePicker, animated: true, completion: {
                    
                })
            }
            else
            {
                DispatchQueue.main.async {
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
            
            DispatchQueue.main.async {
                self.present(actionsheet, animated: true, completion: nil)
            }
        }
        else
        {
            DispatchQueue.main.async {
                self.present(actionsheet, animated: true, completion: nil)
            }
        }
    }
    
    /*------------------------------------------------------
     Below method will be updating the new assembly image for new generated assembly id in previous screen. and after succussful response according to the baseClass identifire the segue will get unwind to base class flow is being initiated. ie. either ScanBarcodePreSurgeryViewController or GoToTrayVC
     ------------------------------------------------------*/
    @IBAction func btnAccept(_ sender: Any)
    {
        if(imageView.image != nil)
        {
            CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)

            //let imgdata = UIImagePNGRepresentation(self.imgPreview.image!)
            
            let url = "\(Constants.kupdateassemblyimagebyassemblyid)/" + (assemblyID as String)
            
            updateTrayPictureWebservice().postTrayImage([:], url, imageView.image!, { (response, err) in
                
                CommanMethods.removeProgrssView(isActivity: true)
                
                if let msg:String = response?[Constants.kstrmessage] as? String
                {
                    if (msg == Constants.kSuccess)
                    {
                        CommanMethods.alertView(alertView: self.alertView, message: Constants.kPre_Surgery_Image_Updated as NSString, viewController: self, type: 1)
                        
//                            /*------------------------------------------------------
//                             the current value of assembly id is being cloned and a new id is being assigned to cloned tray so the further calculation and flow will be driven by new assembly id that is being generated from class SelectImplantPreSurgeryViewController and SelectImplantPreSurgeryTray2ViewController api createpreassemblyclone response
//                             ------------------------------------------------------*/
//
//                            //(self.dicForsaveTrays["trayId"]! as! [Int])[] = [value!]
//
//                            var test = (self.dicForsaveTrays[Constants.kstrtrayId] as! [Any])
//
//                            test[self.trayNumber-1] = Int(self.assemblyID as String)!
//
//                            self.dicForsaveTrays["trayId"]  = test
//
//                            /*------------------------------------------------------
//                             this code unwind the segue to either ScanBarcodePreSurgeryViewController or GoToTrayVC
//                             ------------------------------------------------------*/
//
//                            if(self.strBaseClass == Constants.kScanBarcodePreSurgeryViewController)
//                            {
//                                self.performSegue(withIdentifier: "unwindToGoToScanBarCodePreSurgeryWithSegue", sender: nil)
//                            }
//                            else
//                            {
//                                self.performSegue(withIdentifier: "GoToTray", sender: nil)
//                            }
//
//                        });
//                        alertController.addAction(btnOk)
//                        self.present(alertController, animated: true, completion: nil)
                    }
                    else
                    {
                        CommanMethods.alertView(message: Constants.kAlert_Please_take_picture_again as NSString , viewController: self, type: 1)
                    }
                }
                else
                {
                    CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
                }
            })
        }
    }
    
    @IBAction func openMenu(_ sender: UIButton){
      CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    /*------------------------------------------------------
     MARK: - UIImagePickerControllerDelegate
     ------------------------------------------------------*/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let mediaType = info[UIImagePickerControllerMediaType] as? String
        {
            /*------------------------------------------------------
             Below code added to accept only the image type element from the imagePicker
             ------------------------------------------------------*/
            if mediaType  == "public.image"
            {
                let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                
                imageData = (UIImagePNGRepresentation(image) as NSData?)!
                
                picker.dismiss(animated: true, completion: nil)
                
                imageView.image = image
            }
            else
            {
                picker.dismiss(animated: true, completion: nil)
                
                CommanMethods.alertView(message: Constants.kAlert_Only_images_allowed as NSString , viewController: self, type: 1)
                
//                self.showOKAlert(title :Constants.kstrError ,message: Constants.kAlert_Only_images_allowed)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        picker.dismiss(animated: true, completion: nil)
    }
}
