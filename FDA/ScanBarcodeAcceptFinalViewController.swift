//
//  ScanBarcodeAcceptFinalViewController.swift
//  FDA
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import UIKit

class ScanBarcodeAcceptFinalViewController: UIViewController {
     var trayType : NSString = ""
    var trayNumber : Int = 0
    @IBOutlet var btnEditImplants: UIButton!
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    var decodedimage:UIImage! = nil
    var dicForImageRecognitionResponse :[String: Any] = [:]
    var arrTrayBaseline :[[String: Any]]! = nil
    var tray :Dictionary <String,Any>! = nil
    var trayDetail:NSDictionary! = nil
    var arrSelectedScrews = NSMutableArray()
    var  overrideHoles:NSMutableArray! = NSMutableArray()
    var dicForsaveTrays:[String:Any] = [:]
    var isEditImplantsVisible:Bool = false
    var isDetectedImageIsAdded:Bool = false
    var gotoTrayDetail:Bool = false
    var value:Any! = nil
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        trayDetail = (tray[Constants.kstrPreAssembly] as! NSArray).firstObject as! NSDictionary
        self.navigationItem.title = "Implant Recognition Tray \((dicForsaveTrays[Constants.kstrtrayId]! as! [Any])[0])"
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        imageView.image = decodedimage
        
        if(isEditImplantsVisible == true)
        {
            btnEditImplants.isHidden = true
        }
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
        if segue.identifier == "goToImplants"
        {
//            let destVC = segue.destination as! EditImplantsViewController
//            destVC.isFromSerachTray = true
//            destVC.image = self.decodedimage
//            destVC.arrTrayBaseline = arrTrayBaseline
//            destVC.dicForsaveTrays = dicForsaveTrays
//            destVC.trayType = trayType
//            destVC.arrTrayType = arrTrayType
//            destVC.trayNumber = 1
//            destVC.dicForImageRecognitionResponse = dicForImageRecognitionResponse
        }
        
        if segue.identifier == "trayDetailFromScanBarcode"
        {
            
            let destVC = segue.destination as! TrayDetailViewController
            destVC.trayNumber = 1
            destVC.totalNumberOfTrays = 1
            destVC.trayType = trayType
            destVC.arrTrayType = arrTrayType
            destVC.dicForsaveTrays = dicForsaveTrays
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
     below methdo will get called when user taps on accept and finish button and will call the api updateDetectedImagebyAssemblyId or saveAssemblyAPICall depending on the variable value of isDetectedImageIsAdded. that is being set in updateDetectedImagebyAssemblyId method of scanBArCodeVC
     ------------------------------------------------------*/
    @IBAction func acceptAndFinish (sender : UIButton)
    {
        gotoTrayDetail = true
        
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        if(isDetectedImageIsAdded == false)
        {
            updateDetectedImagebyAssemblyId(isFromAcceptAndFinish: true)
        }
        else
        {
            saveAssemblyAPICall(isFromAcceptAndFinish: true)
        }
    }
    
    /*------------------------------------------------------
     the below method will get called from method acceptPressed
     ------------------------------------------------------*/

    func updateDetectedImagebyAssemblyId(isFromAcceptAndFinish:Bool){
        
        if(imageView.image != nil)
        {
            
            let urlString =  Constants.updatedetectedimagebyassemblyid + "/\((dicForsaveTrays[Constants.kstrtrayId]! as! [Any])[0])"
            
            updateTrayPictureWebservice().postTrayImage([:], urlString, imageView.image!, { (response, err) in
                
                
                if let msg:String = response?[Constants.kstrmessage] as? String
                {
                    if(msg == Constants.kstrFailed)
                    {
                        CommanMethods.removeProgrssView(isActivity: true)
                        CommanMethods.alertView(message: msg as NSString , viewController: self, type: 1)
//                        self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                        return
                    }
                }
                
                if response != nil
                {
                    self.isDetectedImageIsAdded = true
                    self.saveAssemblyAPICall(isFromAcceptAndFinish: isFromAcceptAndFinish)
                }
            })
        }
    }
    
    /*------------------------------------------------------
     The below method will get called from acceptPressed and updateDetectedImagebyAssemblyId method call and will be calling api saveassembly
     ------------------------------------------------------*/

    func saveAssemblyAPICall(isFromAcceptAndFinish:Bool)
    {
        var popToVC : LandingViewController?
        for vc in (self.navigationController?.viewControllers)!
        {
            if vc is LandingViewController
            {
                popToVC = vc as? LandingViewController
                
                popToVC?.callerClass = ""
                
                if(isFromAcceptAndFinish == false)
                {
                    popToVC?.goToScan = true
                }
            }
        }
        
        let dic = trayDetail[Constants.kstrcaseDetails] as! NSDictionary
        
        var data:Array<Dictionary<String, Any>>! = nil
        let reply = (dicForImageRecognitionResponse["fullResult"]! as! String)
        do {
            data  = try JSONSerialization.jsonObject(with: reply.data(using: .utf8)!, options: .allowFragments) as? Array<Dictionary<String, Any>>
            
            //let firstElement: Dictionary<String, Any> = data!.first!
        }
        catch{
            print ("Handle error")
        }
        
        let dicionaryForTray = [Constants.kstrtrayID:"\((dicForsaveTrays[Constants.kstrtrayId]! as! [Any])[0])",Constants.kcaseID:"\(dic["id"]!)",Constants.ktrayBaseline:data] as Dictionary<String,Any>

        /*------------------------------------------------------
         Api call saveassembly by passing the tray data
         ------------------------------------------------------*/

        CommanAPIs().saveassembly(dicionaryForTray, Constants.saveassembly, { (response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            
            if let msg:String = response?[Constants.kstrmessage] as? String
            {
                if(msg == Constants.kstrFailed)
                {
                    CommanMethods.alertView(message: Constants.kstrFailed as NSString , viewController: self, type: 1)
//                    self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                    return
                }
                else if(msg == "Case with Assembly entities is not found")
                {
                    CommanMethods.alertView(message: "Case with Assembly entities is not found" as NSString , viewController: self, type: 1)
                    //                    self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                    return
                }
                else if(msg == "Failed to update Case Detail Assemble")
                {
                    CommanMethods.alertView(message: "Failed to update Case Detail Assemble" as NSString , viewController: self, type: 1)
                    //                    self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                    return
                }
            }
            
            if response != nil{
                
                self.dicForsaveTrays[Constants.knewAssemblyID] = [response![Constants.knewAssemblyID]!]
                
                let imgdata = UIImagePNGRepresentation(self.imageView.image!)
                let strBase64:String = imgdata!.base64EncodedString(options: .init(rawValue: 0))
                
                self.dicForsaveTrays["\(0)"] = strBase64
                
                if(self.gotoTrayDetail == true)
                {
                    self.performSegue(withIdentifier: Constants.ktrayDetailFromScanBarcode, sender: nil)
                }
                else if let vc = popToVC{
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
            else
            {
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
//                self.showOKAlert(title :Constants.kstrError,message: Constants.kstrWrongResponse)
            }
        })
    }
    
    @IBAction func acceptAndSearch (sender : UIButton){
        
        gotoTrayDetail = false
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        if(isDetectedImageIsAdded == false)
        {
            updateDetectedImagebyAssemblyId(isFromAcceptAndFinish: false)
        }
        else
        {
            saveAssemblyAPICall(isFromAcceptAndFinish: false)
        }
        
    }
    
    @IBAction func openMenu(_ sender: UIButton)
    {
       CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    /*------------------------------------------------------
     The below method will be called from class PreSurgeryAcceptAndTakePictureVC to unwind the segue and will be updating the dicForsaveTrays value for trayId after updating a new assembly id in controller SelectImplantPreSurgery succussful attempt
     ------------------------------------------------------*/
    @IBAction func backToAcceptAndFinishWhileSearchTray(for segue: UIStoryboardSegue)
    {
        if let sourceViewController = segue.source as? SelectedImplantViewController
        {
            arrSelectedScrews = sourceViewController.arrSelectedScrews
            
            if(overrideHoles.count > 0)
            {
                overrideHoles = sourceViewController.overrideHoles!
            }
            decodedimage = sourceViewController.decodedimage
            arrTrayType = sourceViewController.arrTrayType
            dicForsaveTrays = sourceViewController.dicForsaveTrays
            isDetectedImageIsAdded = sourceViewController.isDetectedImageIsAdded
            isEditImplantsVisible = sourceViewController.isEditImplantsVisible
            dicForImageRecognitionResponse = sourceViewController.dicForImageRecognitionResponse
        }
        else  if let sourceViewController = segue.source as? SelectImplantTray2ViewController
        {
            //arrSelectedScrews = sourceViewController.arrSelectedScrews
            
            if(overrideHoles.count > 0)
            {
                overrideHoles = sourceViewController.overrideHoles
            }
            decodedimage = sourceViewController.decodedimage
            arrTrayType = sourceViewController.arrTrayType
            dicForsaveTrays = sourceViewController.dicForsaveTrays
            isDetectedImageIsAdded = sourceViewController.isDetectedImageIsAdded
            isEditImplantsVisible = sourceViewController.isEditImplantsVisible
            dicForImageRecognitionResponse = sourceViewController.dicForImageRecognitionResponse
        }
    }
    
    @IBAction func btnEditImplant(_ sender: Any)
    {
        if(arrTrayType.object(at: 0) as! NSString == "tray 1")
        {
            let btnSender = sender as! UIButton
            
            let selectedImplant = self.storyboard?.instantiateViewController(withIdentifier: Constants.kSelectedImplantViewController) as! SelectedImplantViewController
            
            //selectedImplant.value = value
            
            selectedImplant.dicForImageRecognitionResponse = dicForImageRecognitionResponse
            
            selectedImplant.arrTrayBaseline = arrTrayBaseline
            
            selectedImplant.trayNumber = 1
            
            selectedImplant.value = value
            
            selectedImplant.strBaseClass = "ScanBarCode"
            
            selectedImplant.arrTrayType = arrTrayType
            
            selectedImplant.dicForsaveTrays = dicForsaveTrays
            
            selectedImplant.imageView = imageView.image
            
            if btnSender.tag == 100 {
                selectedImplant.iSelectedGroup = 0
            } else if btnSender.tag == 101 {
                selectedImplant.iSelectedGroup = 1
            } else {
                selectedImplant.iSelectedGroup = 2
            }
            self.navigationController?.pushViewController(selectedImplant, animated: true)
        }
        else
        {
            let selectedImplant = self.storyboard?.instantiateViewController(withIdentifier: Constants.kSelectImplantTray2ViewController) as! SelectImplantTray2ViewController
            
            selectedImplant.dicForImageRecognitionResponse = dicForImageRecognitionResponse
            
            //selectedImplant.value = value
            
            selectedImplant.arrTrayBaseline = arrTrayBaseline
            
            selectedImplant.arrTrayType = arrTrayType
            
            selectedImplant.value = value
            
            selectedImplant.strBaseClass = "ScanBarCode"
            
            selectedImplant.trayNumber = 1
            
            selectedImplant.dicForsaveTrays = dicForsaveTrays
            
            selectedImplant.imageView = imageView.image
            
            self.navigationController?.pushViewController(selectedImplant, animated: true)
        }
    }
}
