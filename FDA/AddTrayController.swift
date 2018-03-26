//
//  AddTrayController.swift
//  FDA
//  Purpose :- The current class is being initiated by ScanBarCodeHomeViewController and ScanBarCodeViewController
//  Created by Kaustubh on 06/09/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class AddTrayController: UIViewController {

    @IBOutlet var lblAddTray: UILabel!
    @IBOutlet var btnAddTray: UIButton!
    var tray :Dictionary <String,Any>! = nil
    var trayType : NSString = ""
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    var dicForsaveTrays:[String:Any] = [:]
    var caseId:Any! = nil
    var isForAddTray : Bool = false
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lblAddTray.text = "Tray " + "Assembly " + "\(tray["id"]!)"
        
        /*------------------------------------------------------
         Updated on 11-Dec-2017 :- Below button title changed from "Tray assign to case" to "Assign tray to Case".
         ------------------------------------------------------*/
        btnAddTray.setTitle("Assign tray to case \((caseId as! [String:Any]) ["id"]!)", for: UIControlState.normal)
        
        var popToVC : ScanBarcodeHomeViewController?
        var popToVC1 : ScanBarcodeViewController?
        for vc in (self.navigationController?.viewControllers)!
        {
            if vc is ScanBarcodeHomeViewController
            {
                popToVC = vc as? ScanBarcodeHomeViewController
                
                popToVC?.isForAddTray = true
            }
            else if vc is ScanBarcodeViewController
            {
                popToVC1 = vc as? ScanBarcodeViewController
                
                popToVC1?.isForAddTray = true
            }
        }
    }        
    
    override func viewDidAppear(_ animated: Bool)
    {
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        let dicionaryforGetPreSurgeryImage = [Constants.kstrtrayID:tray["id"]!]
        
        /*------------------------------------------------------
         Api call getassemblyimagebyassemblyid is being called for getting the image for current assembly id that is being sent from Scanning bar code response in class ScanBarCodeViewController or selecting tray assembly id from ScanBarCodeHomeViewController
         ------------------------------------------------------*/
        CommanAPIs().getAssemblyImage(dicionaryforGetPreSurgeryImage, Constants.getassemblyimagebyassemblyid) { (response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            
            if let msg:String = response?[Constants.kstrmessage] as? String
            {
                if(msg == Constants.kstrFailed)
                {
                    return
                }
            }
            
            if response != nil
            {
                let dataDecoded : Data = Data(base64Encoded: response!["data"] as! String, options: .ignoreUnknownCharacters)!
                
                self.imageView.image = UIImage(data: dataDecoded)
                
            }
            else
            {
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func actionAddTray(_ sender: Any)
    {
        /*------------------------------------------------------
         If there is no image returned from api call getassemblyimagebyassemblyid then the add tray functionality will return the control and tray wont be add
        
         Note(Updated on 11-Dec-1017):- below statement will not be needed from now as client suggested. Because in post surgery when new clone is generated the assembly image wont be linked to the new assembly id. So user will never be able to assign the tray that has been generated in cloning.
         ------------------------------------------------------*/
//        if(imageView.image == nil)
//        {
//            return
//        }
        
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        let dicionaryforGetPreSurgeryImage = [Constants.kstrtrayID : tray["id"]! , Constants.kcaseID : (caseId as! [String:Any]) ["id"]!]
        
        /*------------------------------------------------------
         The following api will be binding the case id that is being selected in surgeryViewController and passed until current screen and the assembly tray id together by passing the releted parameters in api getassignassemblytocase
         ------------------------------------------------------*/
        
        CommanAPIs().getRequest(dicionaryforGetPreSurgeryImage, Constants.getassignassemblytocase) { (response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            
            if let msg:String = response?[Constants.kstrmessage] as? String, msg == Constants.kSuccess
            {
                self.performSegue(withIdentifier: Constants.kaddTrayToTrayDetail , sender: nil)
            }
            else if let msg:String = response?[Constants.kstrmessage] as? String, msg == Constants.kAlert_Duplicate_Record_situation_with_input_parameters
            {
                CommanMethods.alertView(message: Constants.kAlert_Duplicate_Record as NSString, viewController: self, type: 1)
                return
            }
            else if let msg:String = response?[Constants.kstrmessage] as? String
            {
                if(msg == Constants.kstrFailed)
                {
                    CommanMethods.alertView(message: Constants.kstrFailed as NSString, viewController: self, type: 1)
                    return
                }
            }
            else
            {
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
            }
        }
    }
    
    // MARK: - Navigation
    /*------------------------------------------------------
     In a storyboard-based application, you will often want to do a little preparation before navigation
     ------------------------------------------------------*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {            
        if(segue.identifier == Constants.kaddTrayToTrayDetail)
        {
            let obj  =  segue.destination as! ScanBarcodePatientDetailsViewController
            
            tray[Constants.kstrPreAssembly] = [NSMutableDictionary(dictionary: [Constants.kstrcaseDetails : NSMutableDictionary(dictionary: caseId! as! Dictionary<String,Any>)])]
            
            var arrtray = dicForsaveTrays[Constants.ktrayData] as! [[String:Any]]
            var trayData = arrtray[0]
            var tray1 = trayData[Constants.ktrayData] as! [String:Any]
            
            tray1[Constants.kstrPreAssembly] = [NSMutableDictionary(dictionary: [Constants.kstrcaseDetails : NSMutableDictionary(dictionary: caseId! as! Dictionary<String,Any>)])]
            
            trayData[Constants.ktrayData] = tray1
            
            arrtray = [trayData]
            obj.caseId = caseId
            dicForsaveTrays[Constants.ktrayData] = arrtray
            obj.trayType = trayType
            obj.isForAddTray = isForAddTray
            obj.arrTrayType = arrTrayType
            obj.tray = tray
            obj.dicForsaveTrays = dicForsaveTrays
        }
    }
    
    @IBAction func openMenu(_ sender: UIButton)
    {
      CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    /*------------------------------------------------------
     The below method is written for showing image in different controller for making it viewable to user by pushing it in different controller where user can zoom it and see the image clearly . the method is being called by the tap gesture on the image
     ------------------------------------------------------*/    
    @IBAction func tapAction(_ sender: Any)
    {
       CommanMethods.showImage(imageView: imageView, viewController: self)
    }
}
