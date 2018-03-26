//
//  ScanBarcodePostSurgeryViewController.swift
//  FDA
//
//  Created by Innovation Lab on 8/17/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class ScanBarcodePostSurgeryViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CustomAlertDelegate {
    
    var differentiateAlertView = 0
    var alertView = CustomAlertViewController.init()
    var trayType : NSString = ""
    var trayNumber : Int = 0
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    @IBOutlet var lblAssemblyTray: UILabel!
    @IBOutlet var imageView: UIImageView!
    var tray :Dictionary <String,Any>! = nil
    let imagePicker = UIImagePickerController.init()
    var arrTrayBaseline :[[String: Any]]! = [[String: Any]]()
    var decodedimage:UIImage! = nil
    var dicForImageRecognitionResponse :[String: Any] = [:]
    var trayDetail:NSMutableDictionary! = nil
    var dicForsaveTrays:[String:Any] = [:]
    var value:Any! = nil
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        //trayDetail = (tray["preAssembly"] as! NSArray).firstObject as! NSMutableDictionary
        
        lblAssemblyTray.text = "Post Surgery Image for Tray \((dicForsaveTrays[Constants.kstrtrayId]! as! [Any])[0])"
        
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        /*------------------------------------------------------
         api calling for the getting screw details for tray listing
         ------------------------------------------------------*/
        
        let dicionaryForGettingDetails = [Constants.kstrtrayID:(dicForsaveTrays[Constants.kstrtrayId]! as! [Any])[0]] as Dictionary<String,Any>
        
        CommanAPIs().getScrewListing(dicionaryForGettingDetails, Constants.getscrewsdetailsbyassemblyid,{(response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            if response != nil
            {
                /*------------------------------------------------------
                 If response if not nil then create the baseline data for screw status, hole number, screw id
                 ------------------------------------------------------*/
                for i in (0..<response!.count)
                {
                    let tray = response![i]
                    
                    let dic = NSMutableDictionary()
                    dic.setValue("\(tray[Constants.kstrholeNumber]!)", forKey: Constants.kHOLE_NUMBER)
                    
                    if ((tray[Constants.kscrewStatus]! as! String).lowercased() == "present"
                        || (tray[Constants.kscrewStatus]! as! String).lowercased() == "other")
                    {
                        dic.setValue("1", forKey: Constants.kSCREW_ID)
                    }
                    else
                    {
                        dic.setValue("0", forKey: Constants.kSCREW_ID)
                    }
                    
                    dic.setValue((tray[Constants.ktrayGroup]! as! NSString).integerValue, forKey: Constants.kTRAY_GROUP)
                    //dic.setValue("\(tray[Constants.kscrewStatus]!)", forKey: Constants.kSCREW_STATUS)
                    if(self.arrTrayBaseline != nil)
                    {
                        self.arrTrayBaseline.append(dic as! [String : Any])
                    }
                    else
                    {
                        self.arrTrayBaseline = [dic as! Dictionary<String, Any>]
                    }
                }
            }
            else
            {
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
//                self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
            }
        })

        /* api calling for the getting Post Assembly Image
         
        let dicionaryforGetPreSurgeryImage = ["trayID":tray["trayId"]!] as Dictionary<String,Any>
        CommanAPIs().getAssemblyImage(dicionaryforGetPreSurgeryImage, Constants.getpostimagebyassemblyid) { (response,err) in
            if response != nil{
                
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
     The below if the action call of the button of alertView that is customis a delegate method of CustomAlertDelegate. The alertview is same but the actions are different that is being set while calling the alertView custom
     ------------------------------------------------------*/
    func okBtnAction()
    {
        if differentiateAlertView == 0
        {
            self.performSegue(withIdentifier: "goToEditImplants", sender: nil)
        }
        else
        {
            self.performSegue(withIdentifier: "goToEditImplants", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openMenu(_ sender: UIButton)
    {
      CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    /*------------------------------------------------------
     The below method will get called when take image button will get clicked
     ------------------------------------------------------*/
    
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
     MARK: - UIImagePickerControllerDelegate
     ------------------------------------------------------*/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        
        let strUserID =  UserDefaults.standard.value(forKey: Constants.kUserID)
//        let trayId = dicForsaveTrays["trayId"]
//        
//        let dictionaryTray = ["TrayImage": UIImagePNGRepresentation(image),"UserId":strUserID,"trayId":trayId]
//        
//        dicForsaveTrays["Trays"] = ["PreSurgery":[]]
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    /*------------------------------------------------------
     The below method will convert the screw data that is in array format to json format and will be caling the api imageRecognition
     ------------------------------------------------------*/
    @IBAction func actionAccept(_ sender: Any)
    {
        if(imageView.image != nil)
        {
            var json :Any! = nil
            var json1 :Any! = nil
            do
            {
                if let file = Bundle.main.url(forResource: Constants.kexample, withExtension: Constants.kjson)
                {
                    let data = try Data(contentsOf: file)
                    let jsonData = try JSONSerialization.data(withJSONObject: arrTrayBaseline, options: JSONSerialization.WritingOptions.prettyPrinted)
                    json = try JSONSerialization.jsonObject(with: data, options: [])
                    json1 = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    
                    if let object = json as? [String: Any]
                    {
                        // json is a dictionary
                        print(object)
                        print(jsonData)
                    }
                    else if let object = json as? [Any]
                    {
                        // json is an array
                        print(object)
                        print(json1)
                        
                    }
                    else
                    {
                        print(Constants.kAlert_JSON_is_invalid)
                    }
                }
                else
                {
                    print("no file")
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
            
            let imgdata = UIImagePNGRepresentation(imageView.image!)
            let strBase64:String = imgdata!.base64EncodedString(options: .init(rawValue: 0))
            
            let dic = [Constants.kpicture:strBase64,Constants.ktrayBaseline:json1] as [String : Any]
            
            /*------------------------------------------------------
             Api call imageRecognition
             Note:
             Updated on : 15-Dec-2017
             Updation reason : the image recognition api for tray-2 and tray-1 is different and because of that we will be separating the api name by checking the arrTrayType value as tray 1 or tray 2
             ------------------------------------------------------*/
            var strApiName = ""
            
            if(arrTrayType.object(at: 0) as! NSString == "tray 1")
            {
                strApiName = Constants.imageRecognition
            }
            else
            {
                strApiName = Constants.imageRecognitionTray2
            }
            
            CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
            updateTrayPictureWebservice().processImage(dic, strApiName, { (response, err) in
                
                if let msg:Int = response?[Constants.kstrmessage] as? Int
                {
                    if(msg == 1)
                    {
                        CommanMethods.removeProgrssView(isActivity: true)
                        CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
//                        self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                        return
                    }
                }
                
                if response != nil && response![Constants.kstatusFlag] as! Int == 0
                {
                    self.dicForImageRecognitionResponse = response!
                    self.dicForImageRecognitionResponse [Constants.kPreImage] = strBase64
                    let dataDecoded : Data = Data(base64Encoded: response![Constants.kmarkedImage] as! String, options: .ignoreUnknownCharacters)!
                    
                    self.decodedimage = UIImage(data: dataDecoded)
                    
                    DispatchQueue.main.async {
                        
                        self.saveTray()
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
     The below method is written for showing image in different controller for making it viewable to user by pushing it in different controller where user can zoom it and see the image clearly . the method is being called by the tap gesture on the image
     ------------------------------------------------------*/
    
    @IBAction func tapAction(_ sender: Any)
    {
        CommanMethods.showImage(imageView: imageView, viewController: self)
    }
    
    /*------------------------------------------------------
     if there is image then api updatepostimagebyassemblyid will get called rest of the information is in below method
     ------------------------------------------------------*/
    func saveTray()
    {
        if(imageView.image != nil)
        {
            let urlString =  Constants.updatepostimagebyassemblyid + "/\((dicForsaveTrays[Constants.kstrtrayId]! as! [Any])[0])"
            
            //let urlString =  Constants.updatepostimagebyassemblyid + "/1"
            
            CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
            
            /*------------------------------------------------------
             The below api will get called by passing the parameter of current image and then will be updating the image.
             ----------------------     --------------------------------*/
            
            updateTrayPictureWebservice().postTrayImage([:], urlString, imageView.image!, { (response, err) in
                
                CommanMethods.removeProgrssView(isActivity: true)
                
                if let msg:String = response?[Constants.kstrmessage] as? String
                {
                    if(msg == Constants.kstrFailed)
                    {
                        CommanMethods.removeProgrssView(isActivity: true)
                        CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
                        return
                    }
                }
                
                if response != nil
                {
                    self.differentiateAlertView = 0
                    
                    CommanMethods.alertView(alertView: self.alertView, message: Constants.kPost_Surgery_Image_Captured as NSString, viewController: self, type:1)

//                    actionsheet.message = Constants.kAlert_Image_updated
//                    okButton = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//
//                        self.performSegue(withIdentifier: "goToEditImplants", sender: nil)
//                    })
                }
                else
                {
                    self.differentiateAlertView = 0
                    
                    CommanMethods.alertView(alertView: self.alertView, message: "Please Try Again" as NSString, viewController: self, type:1)
                    
//                    actionsheet.message = "Wrong Response"
//                    okButton = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//
//                        self.performSegue(withIdentifier: "goToEditImplants", sender: nil)
//                    })
                }
                
//                actionsheet.addAction(okButton)
//
//
//                DispatchQueue.main.async {
//                    self.present(actionsheet, animated: true, completion: nil)
//                }
            })
        }
        
        if(imageView.image == nil)
        {
            self.performSegue(withIdentifier: "goToEditImplants", sender: nil)
        }
        
    }
    
    /*------------------------------------------------------
     MARK: - Navigation
     In a storyboard-based application, you will often want to do a little preparation before navigation
     ------------------------------------------------------*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "goToEditImplants"
        {
            let destVC = segue.destination as! ScanBarcodeAcceptFinalViewController
            destVC.decodedimage = self.decodedimage
            destVC.arrTrayBaseline = arrTrayBaseline
            destVC.trayType = trayType
            destVC.arrTrayType = arrTrayType
            destVC.trayNumber = trayNumber
            destVC.value = value
            destVC.tray = tray
            destVC.dicForImageRecognitionResponse = dicForImageRecognitionResponse
            destVC.dicForsaveTrays = dicForsaveTrays
        }
    }
}
