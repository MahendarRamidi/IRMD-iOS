//
//  ScanBarcodePreSurgeryViewController.swift
//  FDA
//
//  Created by Innovation Lab on 8/17/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class ScanBarcodePreSurgeryViewController: UIViewController {

    @IBOutlet weak var lblAssembleTray: UILabel!
    @IBOutlet var imageView: UIImageView!
    var trayDetail:NSMutableDictionary! = nil
    var trayType : NSString = ""
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    var dicForsaveTrays:[String:Any] = [:]
    var caseId:Any! = nil
     var trayNumber : Int = 0
    var arrTrayBaseline :[[String: Any]]! = [[String: Any]]()
    var tray :Dictionary <String,Any>! = nil
    var value:Any! = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //trayDetail = (tray["preAssembly"] as! NSArray).firstObject as! NSMutableDictionary
        /*------------------------------------------------------
         api calling for the getting Pre Assembly Image
         ------------------------------------------------------*/
        
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        let dicionaryforGetPreSurgeryImage = [Constants.kstrtrayID:tray[Constants.kstrtrayId]!] as Dictionary<String,Any>
        
        CommanAPIs().getAssemblyImage(dicionaryforGetPreSurgeryImage, Constants.getassemblyimagebyassemblyid) { (response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            
            if let msg:String = response?[Constants.kstrmessage] as? String
            {
                if(msg == Constants.kstrFailed)
                {
                    CommanMethods.removeProgrssView(isActivity: true)
                    CommanMethods.alertView(message: "No assembly image available." , viewController: self, type: 1)
//                    self.showOKAlert(title :Constants.kstrError ,message: "No assembly image available.")
                    self.getAssemblyDetails()
                    return
                }
            }
            
            if response != nil{
                
                
                let dataDecoded : Data = Data(base64Encoded: response!["data"] as! String, options: .ignoreUnknownCharacters)!
                self.imageView.image = UIImage(data: dataDecoded)
                self.getAssemblyDetails()
                
            }
            else
            {
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
//                self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                self.getAssemblyDetails()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        value = ((dicForsaveTrays[Constants.kstrtrayId]! as! [Any])[0])
        
        lblAssembleTray.text = "Assembled Tray \(value!)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnEditImplant(_ sender: UIButton)
    {
        let btnSender = sender
        
        if(arrTrayType.object(at: trayNumber-1) as! NSString == "tray 1")
        {
            print(self.trayType)
            
            let selectedImplant = self.storyboard?.instantiateViewController(withIdentifier: Constants.kSelectImplantPreSurgeryViewController) as! SelectImplantPreSurgeryViewController
                        
            selectedImplant.fullResult = self.arrTrayBaseline
            
            selectedImplant.value = ((dicForsaveTrays[Constants.kstrtrayId]! as! [Any])[0])
            
            selectedImplant.strBaseClass = Constants.kScanBarcodePreSurgeryViewController
            
            if btnSender.tag == 100
            {
                selectedImplant.iSelectedGroup = 0
            }
            else if btnSender.tag == 101
            {
                selectedImplant.iSelectedGroup = 1
            }
            else
            {
                selectedImplant.iSelectedGroup = 2
            }
            selectedImplant.caseId = self.caseId
            
            selectedImplant.dicForsaveTrays = self.dicForsaveTrays
            
            selectedImplant.trayNumber = self.trayNumber
            
            selectedImplant.arrTrayType = self.arrTrayType
            
            selectedImplant.decodedimage = self.imageView.image
            
            self.navigationController?.pushViewController(selectedImplant, animated: true)
        }
        else
        {
            print(self.trayType)
            
            let selectedImplant = self.storyboard?.instantiateViewController(withIdentifier: "SelectImplantPreSurgeryTray2ViewController") as! SelectImplantPreSurgeryTray2ViewController
            
            selectedImplant.arrScrewData = NSMutableArray.init(array: self.arrTrayBaseline)
            
            selectedImplant.strBaseClass = Constants.kScanBarcodePreSurgeryViewController
            
            selectedImplant.caseId = self.caseId

            selectedImplant.value = ((dicForsaveTrays[Constants.kstrtrayId]! as! [Any])[0])
            
            selectedImplant.dicForsaveTrays = self.dicForsaveTrays

            selectedImplant.trayNumber = self.trayNumber
              selectedImplant.arrTrayType = self.arrTrayType
            
            self.navigationController?.pushViewController(selectedImplant, animated: true)
        }
    }
    
    @IBAction func actionUpdateTrayToGoToTray(for segue: UIStoryboardSegue)
    {
        //self.performSegue(withIdentifier: "goToUpdateTray", sender: nil)
    }
    func getAssemblyDetails() -> Void
    {
        //trayNumber = 1;
        
        let value = (dicForsaveTrays[Constants.kstrtrayId] as! NSArray).object(at: 0)
        
//        let value = (dicForsaveTrays["trayId"]! as! [Int])[trayNumber-1]
        
        let dicionaryForGettingDetails = [Constants.kstrtrayID:value]
        CommanAPIs().getScrewListing(dicionaryForGettingDetails,Constants.getscrewsdetailsbyassemblyid,{(response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            if response != nil
            {
                for i in (0..<response!.count)
                {
                    let tray = response![i]
                    let dic = NSMutableDictionary()
                    dic.setValue("\(tray[Constants.kstrholeNumber]!)", forKey: Constants.kHOLE_NUMBER)
                    if let _ = (tray[Constants.kscrewId] as? [String:Any])
                    {
                        let str = (tray[Constants.kscrewId]! as! [String:Any])["id"]
                        dic.setValue("\(str!)", forKey: Constants.kSCREW_ID)
                    }
                    else
                    {
                        dic.setValue("", forKey: Constants.kSCREW_ID)
                    }
                    dic.setValue((tray[Constants.ktrayGroup]! as! NSString).integerValue, forKey: Constants.kTRAY_GROUP)
                    
                    dic.setValue("\(tray[Constants.kscrewStatus]!)", forKey: Constants.kSCREW_STATUS)
                    if(self.arrTrayBaseline != nil)
                    {
                        self.arrTrayBaseline.append(dic as! [String : Any])
                    }
                        
                    else
                    {
                        self.arrTrayBaseline = [dic as! Dictionary<String, Any>]
                    }
                    CommanMethods.removeProgrssView(isActivity: true)
                }
            }
            else
            {
                CommanMethods.removeProgrssView(isActivity: true)
            }
        })
    }
    

    @IBAction func openMenu(_ sender: UIButton){
       CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    //unwindToGoToScanBarCodePreSurgeryWithSegue
    @IBAction func unwindToGoToScanBarCodePreSurgery(segue:UIStoryboardSegue)
    {
        if let sourceViewController = segue.source as? PresurgeryAcceptAndTakePictureViewController
        {
            dicForsaveTrays = sourceViewController.dicForsaveTrays
            
            self.trayType = sourceViewController.trayType
            
            self.arrTrayType = sourceViewController.arrTrayType
            
            self.imageView.image = sourceViewController.imageView.image
            
            self.caseId = sourceViewController.caseId
            
            self.arrTrayBaseline = NSMutableArray.init() as! [[String : Any]]
            
            self.getAssemblyDetails()
        }
        print(Constants.kSuccess)
    }
    
    /*------------------------------------------------------
     The below method is written for showing image in different controller for making it viewable to user by pushing it in different controller where user can zoom it and see the image clearly . the method is being called by the tap gesture on the image
     ------------------------------------------------------*/
    
    @IBAction func tapAction(_ sender: Any)
    {
       CommanMethods.showImage(imageView: imageView, viewController: self)
    }
    
    /*------------------------------------------------------
     MARK: - Navigation
     In a storyboard-based application, you will often want to do a little preparation before navigation
     ------------------------------------------------------*/

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {        
        /*------------------------------------------------------
         Get the new view controller using segue.destinationViewController.
         Pass the selected object to the new view controller.
         ------------------------------------------------------*/
        if(segue.identifier == "gotoPost")
        {
            let objScanBarcodePostSurgeryViewController = segue.destination as! ScanBarcodePostSurgeryViewController
            objScanBarcodePostSurgeryViewController.tray = tray
            objScanBarcodePostSurgeryViewController.arrTrayType = arrTrayType
            objScanBarcodePostSurgeryViewController.value = value
            objScanBarcodePostSurgeryViewController.dicForsaveTrays = dicForsaveTrays
        }
        
        if(segue.identifier == "goToUpdateImage")
        {
            let objUpdateTrayViewController = segue.destination as! UpdateTrayViewController
            objUpdateTrayViewController.dicForsaveTrays = dicForsaveTrays
            objUpdateTrayViewController.trayNumber = 1
        }
    }
}
