//
//  ScanBarcodeViewController.swift
//  FDA
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import UIKit

class ScanBarcodeViewController: UIViewController {

    var dicForsaveTrays:[String:Any] = [:]
    var tray :Dictionary <String,Any>? = nil
    var isForAddTray : Bool = false
    var caseId:Any! = nil
    var trayType : NSString = ""
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func actionSave(_ sender: Any)
    {
        let btn = sender as! UIButton

        if(btn.accessibilityValue == nil)
        {
            return
        }

        let dicionaryForTray = [Constants.kstrtrayId:btn.accessibilityValue!] as Dictionary<String,Any>
        
//        let dicionaryForTray = [Constants.kstrtrayId:"bar1"] as Dictionary<String,Any>
        
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        /*----------------------------------------------------------------------------------------
         For normal:-
         Api name :- searchtraybyidforassigntray
         Reason :- flow there wont be any details coming for the case id those are not bind with any other assembly id.
         For add tray flow:-
         Api name :- searchtraybybarcode
         Reason :- for add tray flow the data will be coming regardless of any binding between case id or assembly id
         -----------------------------------------------------------------------------------------*/

        var apiName = ""
        
        if(self.isForAddTray == true)
        {
            apiName = Constants.ksearchtraybybarcodeforassigntray
        }
        else
        {
            apiName = Constants.getsearchtraybybarcode
        }
        
        /* api calling for the tray listing */

        SurgeryViewWebservises().getScanPatient(dicionaryForTray, apiName,{(response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            //This tray has already been assigned to a case
            /*------------------------------------------------------
             if the response is failed the display toast with failed
             ------------------------------------------------------*/
            if let msg:String = response?[Constants.kstrmessage] as? String
            {
                if(msg == Constants.kstrFailed)
                {
                    CommanMethods.removeProgrssView(isActivity: true)
                    CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
//                    self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                    return
                }
            }
            
            /*------------------------------------------------------
             if the response is not nil then get the assembly details for particular case id
             ------------------------------------------------------*/
            
            if response != nil
            {
                self.dicForsaveTrays[Constants.kstrtrayId] = [response!["id"]!]
                
                //self.dicForsaveTrays["trayData"] = [["trayData":response!]]
                //                let dicionaryForTray = ["patientId":self.dicForsaveTrays["patientId"] as! String,"surgeonName":self.dicForsaveTrays["surgeonName"]  as! String,"surgeryTypeId":self.dicForsaveTrays["surgeryTypeId"]  as! String,"date":self.dicForsaveTrays["date"]  as! String] as Dictionary<String,Any>
                var arrCasedetails = [[String:AnyObject]]()
                
                if ((response![Constants.kstrPreAssembly] as! [[String:Any]]).count) > 0
                {
                    arrCasedetails = (response![Constants.kstrPreAssembly] as! [[String:Any]]).flatMap { $0[Constants.kstrcaseDetails] } as! [[String:AnyObject]]
                }
                else
                {
                    arrCasedetails = (response![Constants.kstrrefAssembly] as! [[String:Any]]).flatMap { $0[Constants.kstrcaseDetails] } as! [[String:AnyObject]]
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                arrCasedetails = arrCasedetails.sorted
                {
                    formatter.date(from: $0[Constants.kstrcaseDate]! as! String)?.compare(formatter.date(from: $1[Constants.kstrcaseDate]! as! String)!) != .orderedAscending
                }
                
                var dicCaseDetails:[[String:Any]]! = [[String:Any]]()
                for obj in arrCasedetails
                {
                    dicCaseDetails.append([Constants.kstrcaseDetails : obj])
                }
                
                var newResponse = response!
                
                newResponse[Constants.kstrPreAssembly] = dicCaseDetails
                
                var tempObj = NSMutableArray.init(array: dicCaseDetails)
                
                self.dicForsaveTrays[Constants.ktrayData] = [[Constants.ktrayData:newResponse]]
                
                self.tray = newResponse
                
                /*------------------------------------------------------
                 The below code will only get called if add tray flow is false
                 ------------------------------------------------------*/
                if (!(self.isForAddTray == true))
                {
                    if tempObj.count > 0
                    {
                        self.caseId = (tempObj.object(at: 0) as! NSDictionary).value(forKey: Constants.kstrcaseDetails)
                    }
                }

                self.tray?[Constants.kstrtrayId] = response!["id"]!
                
                let dictTemp = response![Constants.kproduct] as? [String:Any]
                
                self.trayType = (dictTemp?["type"] as? NSString)!
                
                self.arrTrayType = NSMutableArray.init()
                
                self.arrTrayType.add(self.trayType)
                
                if(self.isForAddTray == true)
                {
                    self.performSegue(withIdentifier: "toAddtrayScreen", sender: nil)
                    self.isForAddTray = false
                }
                else
                {
                    self.performSegue(withIdentifier: Constants.kgoToScanPatientDetail, sender: nil)
                }
            }
            else
            {
                /*------------------------------------------------------
                 Updated on 12-Dec-2017 :- for add tray if any trayId has already been assign to any other case then response will be nil and we need to display msg as "This tray has already been assigned to a case". and for normal search by id if no case has been assign to any tray then api response will be nil and it will be showing msg as "This tray has not been associated with any case"
                 ------------------------------------------------------*/
                var msg = ""
                
                if(self.isForAddTray == true)
                {
                    msg = Constants.kAlert_This_tray_has_already_been_assigned_to_a_case
                }
                else
                {
                    msg = Constants.kAlert_case_details_are_not_bind
                }
                
                CommanMethods.alertView(message: msg as NSString , viewController: self, type: 1)
            }
        })
    }
    
    @IBAction func openMenu(_ sender: UIButton)
    {
       CommanMethods.openSideMenu(navigationController: navigationController!)
    }

    /*------------------------------------------------------
     The below method will initialize the bar code scanner subview as QRScannerController
     ------------------------------------------------------*/
    @IBAction func actionStartSearchingBarcode(_ sender: Any)
    {
        
        let objQRScannerController = self.childViewControllers[0] as! QRScannerController
        
        objQRScannerController.captureSession?.startRunning()
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

        if(segue.identifier == "goToScanPatientDetail")
        {
            let obj  =  segue.destination as! ScanBarcodePatientDetailsViewController
            obj.tray = tray
            obj.trayType = trayType
            obj.arrTrayType = arrTrayType
            obj.caseId = caseId
            obj.dicForsaveTrays = dicForsaveTrays
            
        }
        else if(segue.identifier == "toAddtrayScreen")
        {
            let obj  =  segue.destination as! AddTrayController
            obj.tray = tray
            obj.isForAddTray = isForAddTray
            obj.dicForsaveTrays = dicForsaveTrays
            obj.trayType = trayType
            obj.arrTrayType = arrTrayType
            obj.caseId = caseId
        }
    }
}
