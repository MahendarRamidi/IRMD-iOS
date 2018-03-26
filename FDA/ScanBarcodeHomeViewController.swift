 //
//  ScanBarcodeHomeViewController.swift
//  FDA
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import UIKit

class ScanBarcodeHomeViewController: UIViewController {
    
    var tray :Dictionary <String,Any>? = nil
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    var dicForsaveTrays:[String:Any] = [:]
    var isForAddTray : Bool = false
    var caseId:Any! = nil
    var trayType : NSString = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var popToVC : LandingViewController?
        var popToVC1 : ChooseWorkflowViewController?
        for vc in (self.navigationController?.viewControllers)!
        {
            if vc is LandingViewController
            {
                popToVC = vc as? LandingViewController
                
                popToVC?.callerClass = ""
            }
            else if vc is ChooseWorkflowViewController
            {
                popToVC1 = vc as? ChooseWorkflowViewController
                
                popToVC1?.callerClass = ""
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "searchById")
        {
            let obj  =  segue.destination as! ScanBarcodePatientDetailsViewController
            obj.tray = tray
            obj.trayType = trayType
            obj.arrTrayType = arrTrayType
            obj.dicForsaveTrays = dicForsaveTrays
            obj.caseId = caseId
        }
        else if(segue.identifier == "addTray")
        {
            let obj  =  segue.destination as! AddTrayController
            obj.tray = tray
            obj.isForAddTray = isForAddTray
            obj.dicForsaveTrays = dicForsaveTrays
            obj.arrTrayType = arrTrayType
            obj.trayType = trayType
            obj.caseId = caseId
        }
        else if(segue.identifier == "barcodeScreen")
        {
            let obj  =  segue.destination as! ScanBarcodeViewController
            obj.isForAddTray = isForAddTray
            obj.trayType = trayType
            obj.arrTrayType = arrTrayType
            obj.caseId = caseId
        }
    }
    
    @IBAction func openMenu(_ sender: UIButton)
    {
        CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    /*------------------------------------------------------
     The below method is being called from class DrawerMenuVC to perform side menu functionality to land on current page
     ------------------------------------------------------*/
    func searchByScan()
    {
        self.performSegue(withIdentifier: "scanBarCode", sender: nil)
    }
    
    @IBAction func actionScanById(_ sender: Any)
    {        
        CommanMethods.alertView(message: Constants.kAlertPlease_enter_email as NSString, viewController: self, type: 2)
    }
    
    /*------------------------------------------------------
     Below method will be called from the class CustomeAlertView and will be passing the data of tray id in text field in current controller
     ------------------------------------------------------*/
    func getTrayValueFromAlert(trayID : NSString)->Void
    {
        if (trayID.length == 0)
        {
            return
        }
        
        let dicionaryForTray = [Constants.kstrtrayId:trayID] as Dictionary<String,Any>
            
            /* api calling for the tray listing */
            
            CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
            
            var apiName = ""
            
            /*----------------------------------------------------------------------------------------
             For normal:-
             Api name :- searchtraybyidforassigntray
             Reason :- flow there wont be any details coming for the case id those are not bind with any other assembly id.
             For add tray flow:-
             Api name :- getsearchtraybyid
             Reason :- for add tray flow the data will be coming regardless of any binding between case id or assembly id
             -----------------------------------------------------------------------------------------*/
            
            if(self.isForAddTray == true)
            {
                apiName = Constants.ksearchtraybynumberforassigntray
            }
            else
            {
                apiName = Constants.ksearchtraybytraynumber
            }
            
            SurgeryViewWebservises().getScanPatient(dicionaryForTray, apiName ,{(response,err) in
                
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
                    self.dicForsaveTrays[Constants.kstrtrayId] = ["\(response!["id"]!)"]
                    
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
                    
                    arrCasedetails = arrCasedetails.sorted {
                        formatter.date(from: $0[Constants.kstrcaseDate]! as! String)?.compare(formatter.date(from: $1[Constants.kstrcaseDate]! as! String)!) != .orderedAscending
                    }
                    
                    var dicCaseDetails:[[String:Any]]! = [[String:Any]]()
                    for obj in arrCasedetails{
                        
                        dicCaseDetails.append([Constants.kstrcaseDetails : obj])
                        
                    }
                    
                    var newResponse = response!
                    newResponse[Constants.kstrPreAssembly] = dicCaseDetails
                    
                    self.dicForsaveTrays[Constants.ktrayData] = [[Constants.ktrayData:newResponse]]
                    self.tray = newResponse
                    
                    var tempObj = NSMutableArray.init(array: dicCaseDetails)
                    
                    if (!(self.isForAddTray == true))
                    {
                        if tempObj.count > 0
                        {
                            self.caseId = (tempObj.object(at: 0) as! NSDictionary).value(forKey: Constants.kstrcaseDetails)
                        }
                    }
                    
                    self.tray?[Constants.kstrtrayId] = (response!["id"]!)
                    //self.dicForsaveTrays["PreSurgery"] = response!
                    
                    let dictTemp = response![Constants.kproduct] as? [String:Any]
                    
                    self.trayType = (dictTemp?["type"] as? NSString)!
                    
                    self.arrTrayType = NSMutableArray.init()
                    
                    self.arrTrayType.add(self.trayType)
                    
                    if(self.isForAddTray == true)
                    {
                        self.performSegue(withIdentifier: "addTray", sender: nil)
                        self.isForAddTray = false
                    }
                    else
                    {
                        self.performSegue(withIdentifier: "searchById", sender: nil)
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
        print(trayID)
    }
}
