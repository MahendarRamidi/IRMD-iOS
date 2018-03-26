 //
//  AcceptTrayStep1ViewController.swift
//  FDA
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import UIKit

class AcceptTrayStep1ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, CustomAlertDelegate
{
    var differentiateAlertView = 0;
    @IBOutlet var lblAssemblyTray: UILabel!
    var alertView = CustomAlertViewController.init()
    var trayType : NSString = ""
    var trayNumber : Int = 0
    var totalNumberOfTrays = 0
    var decodedimage:UIImage! = nil
    var dicForImageRecognitionResponse :[String: Any] = [:]
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    @IBOutlet var imageView: UIImageView!
    var dicForsaveTrays :[String: Any] = [:]
    let imagePicker = UIImagePickerController.init()
    var arrTrayBaseline :[[String: Any]]! = [[String: Any]]()
    var arrTrayData : NSMutableArray = NSMutableArray.init()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /*------------------------------------------------------
         For testing purpose we are using the photoLibrary
         ------------------------------------------------------*/
        
        imagePicker.delegate = self
        
        let value = (dicForsaveTrays[Constants.kstrtrayId]! as! [Int])[trayNumber-1]
        
        lblAssemblyTray.text = "Post Surgery Image for Tray \(value)"
        
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        /*------------------------------------------------------
         api calling for the getting screw details for tray listing
         ------------------------------------------------------*/
        
        let dicionaryForGettingDetails = [Constants.kstrtrayID:value]
        
        CommanAPIs().getScrewListing(dicionaryForGettingDetails, Constants.getscrewsdetailsbyassemblyid,{(response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            if response != nil
            {
                /*------------------------------------------------------
                 Using below code the arrayBaseLine will be prepared from screwid, holenumber, status and traygroup that is being received from the api response getscrewsdetailsbyassemblyid
                 ------------------------------------------------------*/
                for i in (0..<response!.count)
                {
                    let tray = response![i]
                    
                    let dic = NSMutableDictionary()
                   
                    let dicForStatus = NSMutableDictionary()
                    
                    dic.setValue("\(tray[Constants.kstrholeNumber]!)", forKey: Constants.kHOLE_NUMBER)
                    dicForStatus.setValue("\(tray[Constants.kstrholeNumber]!)", forKey: Constants.kHOLE_NUMBER)
                    
                    if ((tray[Constants.kscrewStatus]! as! String).lowercased() == "present"
                        || (tray[Constants.kscrewStatus]! as! String).lowercased() == "other")
                    {
                        dic.setValue(1, forKey: Constants.kSCREW_ID)
                        dicForStatus.setValue(1, forKey: Constants.kSCREW_ID)
                    }
                    else
                    {
                        dic.setValue(0, forKey: Constants.kSCREW_ID)
                        dicForStatus.setValue(0, forKey: Constants.kSCREW_ID)
                    }

                    dic.setValue((tray[Constants.ktrayGroup]! as! NSString).integerValue, forKey: Constants.kTRAY_GROUP)
                    
                    dicForStatus.setValue((tray[Constants.ktrayGroup]! as! NSString).integerValue, forKey: Constants.kTRAY_GROUP)
                    dicForStatus.setValue("\(tray[Constants.kscrewStatus]!)", forKey: Constants.kSCREW_STATUS)
                    /*------------------------------------------------------
                     If the data already present in arrayTrayBaseline then it will get append in array else create a new array
                     ------------------------------------------------------*/
                    if(self.arrTrayBaseline != nil)
                    {
                        self.arrTrayBaseline.append(dic as! [String : Any])
                        self.arrTrayData.add(dicForStatus)
                    }
                    else
                    {
                        self.arrTrayBaseline = [dic as! Dictionary<String, Any>]
                        self.arrTrayData =  [dicForStatus as! Dictionary<String, Any>]
                    }
                    
                }
            }
            else
            {
                CommanMethods.removeProgrssView(isActivity: true)
            }
        })
 
//        }
//        else{
//                    self.showOKAlert(title :"Error" ,message: "Wrong Response.")
//        }
        /* api calling for the getting Post Assembly Image
        
         Not need to call this api we do not need to show image form DB here
         
         let dicionaryforGetPreSurgeryImage = ["trayID":dicForsaveTrays["trayId"]!] as Dictionary<String,Any>
        CommanAPIs().getAssemblyImage(dicionaryforGetPreSurgeryImage, Constants.getpostimagebyassemblyid) { (response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            if let msg:String = response?["message"] as? String
            {
                if(msg == Constants.kstrFailed)
                {
                    self.showOKAlert(title :"Error" ,message: "Wrong Response.")
                    return
                }
            }
            if response != nil {

                let dataDecoded : Data = Data(base64Encoded: response!["data"] as! String, options: .ignoreUnknownCharacters)!
                self.imageView.image = UIImage(data: dataDecoded)
            }
            else{
                self.showOKAlert(title :"Error" ,message: "Wrong Response.")
            }
        }
        
        */
        /*------------------------------------------------------
         Below code if for preparing alert view for presenting as alert box and setting the delegate as current class. that will be helpful in calling the action of okbutton when user taps on ok button in alert view
         ------------------------------------------------------*/
        alertView = self.storyboard?.instantiateViewController(withIdentifier: Constants.kCustomAlertViewController) as! CustomAlertViewController
        
        alertView.delegate = self
     }
    
    /*------------------------------------------------------
     MARK: - UIImagePickerControllerDelegate
     ------------------------------------------------------*/
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        
        let strUserID =  UserDefaults.standard.value(forKey: Constants.kUserID)
        let trayID = dicForsaveTrays[Constants.kstrtrayId]
        
        let dictionaryTray = ["TrayImage": UIImagePNGRepresentation(image),"UserId":strUserID,Constants.kstrtrayId:trayID]
        
        dicForsaveTrays["Trays"] = ["PreSurgery":[]]
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    /*------------------------------------------------------
     MARK: - Navigation
     In a storyboard-based application, you will often want to do a little preparation before navigation
     ------------------------------------------------------*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "goToStep2"
        {
            let destVC = segue.destination as! AcceptTrayStep2ViewController
            destVC.trayNumber = trayNumber
            destVC.arrTrayBaseline = self.arrTrayBaseline
            destVC.arrTrayData = self.arrTrayData
            destVC.totalNumberOfTrays = totalNumberOfTrays
            destVC.image = self.decodedimage
            destVC.dicForsaveTrays = dicForsaveTrays
            destVC.trayType = trayType
            destVC.arrTrayType = arrTrayType
            destVC.dicForImageRecognitionResponse = dicForImageRecognitionResponse
        }
    }
    
    /*------------------------------------------------------
     Below method wll be initiating the popover for selecting the image from UIImagePickerController
     ------------------------------------------------------*/
    @IBAction func actionTakePicture(_ sender: Any)
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
            
            self.present(actionsheet, animated: true, completion: {
                
            })
        }
        else
        {
            DispatchQueue.main.async {
                self.present(actionsheet, animated: true, completion: nil)
            }
        }
    }
    
    /*------------------------------------------------------
     The below method will re initiate the popover of UIImagePickerController again
     ------------------------------------------------------*/
    @IBAction func actionRetakeImage(_ sender: Any) {
        
        self.actionTakePicture(sender)
    }
    
    /*------------------------------------------------------
     The below method will get called when user clicks on accept button in controller. Rest of the information available inside method
     ------------------------------------------------------*/
    @IBAction func acceptPressed(sender : UIButton)
    {
        /*------------------------------------------------------
         If image available then the jsonData will be created using arrTrayBaseline object using JSONSerialization conversion
         ------------------------------------------------------*/
        if(imageView.image != nil)
        {
            var json1 :Any! = nil
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: arrTrayBaseline, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                json1 = try JSONSerialization.jsonObject(with: jsonData, options: [])
            }
            catch
            {
                print(error.localizedDescription)
            }
            
            let imgdata = UIImagePNGRepresentation(imageView.image!)
            
            let strBase64:String = imgdata!.base64EncodedString(options: .init(rawValue: 0))
            
            let dic = [Constants.kpicture:strBase64, Constants.ktrayBaseline:json1] as [String : Any]
            
            CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
            
            /*------------------------------------------------------
             Api call for image recognition. by sending the image dictionary of jsonData created above
             
             Note:
             Updated on : 15-Dec-2017
             Updation reason : the image recognition api for tray-2 and tray-1 is different and because of that we will be separating the api name by checking the arrTrayType value as tray 1 or tray 2
             ------------------------------------------------------*/
            var strApiName = ""
            
            if(arrTrayType.object(at: trayNumber-1) as! NSString == "tray 1")
            {
                strApiName = Constants.imageRecognition
            }
            else
            {
                strApiName = Constants.imageRecognitionTray2
            }
            updateTrayPictureWebservice().processImage(dic, strApiName, { (response, err) in
                
                /*------------------------------------------------------
                 If failed show wronge response
                 ------------------------------------------------------*/
                if let msg:String = response?[Constants.kstrmessage] as? String
                {
                    CommanMethods.removeProgrssView(isActivity: true)
                    CommanMethods.alertView(message: msg as NSString , viewController: self, type: 1)
//                    self.showOKAlert(title :Constants.kstrError ,message:msg)
                        return
                }

                /*------------------------------------------------------
                 if response then create decodedimage using response image data and display
                 ------------------------------------------------------*/
                if response != nil && response![Constants.kstatusFlag] as! Int == 0 {
                    
                    self.dicForImageRecognitionResponse = response!
                    self.dicForImageRecognitionResponse [Constants.kPreImage] = strBase64
                   
                    self.dicForsaveTrays["\(self.trayNumber - 1)"] = response![Constants.kmarkedImage] as! String
                    
                    let dataDecoded : Data = Data(base64Encoded: response![Constants.kmarkedImage] as! String, options: .ignoreUnknownCharacters)!
                    self.decodedimage = UIImage(data: dataDecoded)
                    
                    /*------------------------------------------------------
                     Call saveTray method for updating post image by calling updatePostImagebyId api
                     ------------------------------------------------------*/
                    DispatchQueue.main.async
                    {
                        self.saveTray(sender: sender)
                    }
                }
                else
                {
                    CommanMethods.alertView(message: Constants.kAlert_Please_take_picture_again as NSString , viewController: self, type: 1)
//                    self.showOKAlert(title :Constants.kstrError ,message: Constants.kAlert_Please_take_picture_again)
                    
                    DispatchQueue.main.async {
                        CommanMethods.removeProgrssView(isActivity: true)
                     }
                }
            })
        }
    }
    
    /*------------------------------------------------------
     Below method called by method acceptButtonpressed method after successful response of image recognition api
     ------------------------------------------------------*/
    func saveTray(sender : UIButton)
    {
        if(imageView.image != nil)
        {
            let value = (dicForsaveTrays[Constants.kstrtrayId]! as! [Int])[trayNumber-1]
            //if let value = dicForsaveTrays["trayId"]{
            let urlString =  Constants.updatepostimagebyassemblyid + "/\(value)"
            //let urlString =  Constants.updatepostimagebyassemblyid + "/1"
            
            CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
            
            updateTrayPictureWebservice().postTrayImage([:], urlString, imageView.image!, { (response, err) in
                
                CommanMethods.removeProgrssView(isActivity: true)
                
//                let actionsheet = UIAlertController.init(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
                
//                var okButton:UIAlertAction! = nil
                
                if let msg:String = response?[Constants.kstrmessage] as? String
                {
                    if(msg == Constants.kstrFailed)
                    {
                        CommanMethods.removeProgrssView(isActivity: true)
                        CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
//                        self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                        return
                    }
                }
                
                if response != nil
                {
                    self.differentiateAlertView = 0
                    
                    CommanMethods.alertView(alertView: self.alertView, message: Constants.kPost_Surgery_Image_Captured as NSString, viewController: self, type: 1)
//                    okButton = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//
//
//                    })
                }
                else
                {
                    self.differentiateAlertView = 1
                    
                    CommanMethods.alertView(alertView: self.alertView, message: "Wrong Response" as NSString, viewController: self, type: 1)

//                    actionsheet.message = "Wrong Response"
//                    okButton = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//
//                        self.performSegue(withIdentifier: "goToStep2", sender: nil)
//                    })
                }
                
//                actionsheet.addAction(okButton)
                
//                DispatchQueue.main.async {
//                    self.present(actionsheet, animated: true, completion: nil)
//                }
            })
        }
        
        if(imageView.image == nil)
        {
            self.performSegue(withIdentifier: "goToStep2", sender: nil)
        }
        
    }

    @IBAction func openMenu(_ sender: UIButton)
    {
        CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    /*------------------------------------------------------
     The below if the action call of the button of alertView that is customis a delegate method of CustomAlertDelegate. The alertview is same but the actions are different that is being set while calling the alertView custom
     ------------------------------------------------------*/
    func okBtnAction()
    {
        if differentiateAlertView == 0
        {
            self.performSegue(withIdentifier: "goToStep2", sender: nil)
        }
        else
        {
            self.performSegue(withIdentifier: "goToStep2", sender: nil)
        }
    }
    
    /*------------------------------------------------------
     The below method is written for showing image in different controller for making it viewable to user by pushing it in different controller where user can zoom it and see the image clearly . the method is being called by the tap gesture on the image
     ------------------------------------------------------*/
    
    @IBAction func tapAction(_ sender: Any)
    {
       CommanMethods.showImage(imageView: imageView, viewController: self)
    }
}
public enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

extension UIImage {
    
    public func base64(format: ImageFormat) -> String? {
        var imageData: Data?
        switch format {
        case .png: imageData = UIImagePNGRepresentation(self)
        case .jpeg(let compression): imageData = UIImageJPEGRepresentation(self, compression)
        }
        return imageData?.base64EncodedString()
    }
}
