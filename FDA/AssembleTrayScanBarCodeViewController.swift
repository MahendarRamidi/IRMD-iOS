//
//  AssembleTrayScanBarCodeViewController.swift
//  FDA
//  Purpose :- this class has been created for scaning the bar code for tray-1 and tray-2 for bar code scan and product scan both so this class will be called from chooseWorkFlowVC , AssembleTrayEditImplantViewController and AssembleTrayEditImplantTray2ViewController classes
//  Created by CYGNET on 23/10/17.
//  Copyright © 2017 Aditya. All rights reserved.

import UIKit

/*------------------------------------------------------
 The below method is a declaration of delegate method of current class. The Definition of below method is written in the AssembleTrayEditImplantViewController and AssembleTrayEditImplantTray2ViewController classes
 ------------------------------------------------------*/

protocol AssembleTrayScanBarCodeViewControllerDelegate
{
    func validateScrewForProductApiResponse(response : Bool)->Void
    func getScrewID(implantScrewID : NSString) -> Void    
}

class AssembleTrayScanBarCodeViewController: UIViewController,CustomAlertDelegate
{
    var alertView = CustomAlertViewController.init()
    
    @IBOutlet weak var lblScanTrayBarCode: UIButton!
    
    var dictImagData = NSMutableDictionary.init()
    
    var newResponse = NSMutableDictionary.init()
    
    var trayType : NSString = ""
    
    var screwID : NSString = ""
    
    var tray :Dictionary <String,Any>? = nil
    
    var identifyVC : NSString = ""
    
    var  overrideHoles:NSMutableArray! = NSMutableArray()
    
    var arrScrewData : NSMutableArray = []
    
    var delegate: AssembleTrayScanBarCodeViewControllerDelegate?
    
    var scanBarcodeString : NSString = ""
    
    var differentiateAlertView = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
 
        /*------------------------------------------------------
         As this class is being called from chooseWorkFlowVC and AssembleTrayEditImplantViewController/ AssembleTrayEditImplantTray2ViewController so for differentiating the button title and action we need to change the button title at run time
         ------------------------------------------------------*/
        
        if self.identifyVC as String == Constants.kstrgotoEditImplant
        {
            self.lblScanTrayBarCode.setTitle("Scan implant barcode", for: UIControlState.normal)
        }
        /*------------------------------------------------------
         Below code if for preparing alert view for presenting as alert box and setting the delegate as current class. that will be helpful in calling the action of okbutton when user taps on ok button in alert view
         ------------------------------------------------------*/
        alertView = self.storyboard?.instantiateViewController(withIdentifier: Constants.kCustomAlertViewController) as! CustomAlertViewController
        
        alertView.delegate = self
        /*------------------------------------------------------*/
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
        if(differentiateAlertView == 0)
        {
            /*------------------------------------------------------
             Updated on 19-Jan-2018 12:29 PM
             
             The below delegate method call will be setting the screwID parameter that is being fetched from the api response searchimplantybybarcode
             ------------------------------------------------------*/
            self.delegate?.getScrewID(implantScrewID: screwID)
            
            self.delegate?.validateScrewForProductApiResponse(response: true)
            
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            let arrHoleNum = (self.dictImagData.value(forKey: Constants.kassemblyDetails) as! NSMutableArray).value(forKey: Constants.kstrholeNumber) as! NSArray
            
            let arrScrewStatus = (self.dictImagData.value(forKey: Constants.kassemblyDetails) as! NSMutableArray).value(forKey: Constants.kscrewStatus) as! NSArray
            
            let arrtrayGroup = (self.dictImagData.value(forKey: Constants.kassemblyDetails) as! NSMutableArray).value(forKey: Constants.kstrtrayGroup) as! NSArray
            
            let arrScrewID = ((((self.dictImagData.value(forKey:"assemblyDetails")) as! NSArray).value(forKey: "screwId")) as! NSArray).value(forKey: "id") as! NSArray
            
            let arrData = NSMutableArray()
            
            var dictData = NSMutableDictionary()
            
            for i in 0..<arrHoleNum.count
            {
                dictData = NSMutableDictionary()
                
                dictData.setValue(arrHoleNum[i], forKey: Constants.kstrholeNumber)
                
                dictData.setValue(arrScrewStatus[i], forKey: Constants.kscrewStatus)
                
                dictData.setValue(arrtrayGroup[i], forKey: Constants.kstrtrayGroup)
                
                dictData.setValue(arrScrewID[i], forKey: Constants.kscrewID)
                
                arrData.add(dictData.mutableCopy())
            }
            
            self.arrScrewData = arrData
            
            var arrCasedetails = (self.newResponse[Constants.kstrPreAssembly] as! [[String:Any]]).flatMap { $0[Constants.kstrcaseDetails] } as! [[String:AnyObject]]
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = Constants.kDateFormat
            
            arrCasedetails = arrCasedetails.sorted {
                formatter.date(from: $0[Constants.kstrcaseDate]! as! String)?.compare(formatter.date(from: $1[Constants.kstrcaseDate]! as! String)!) != .orderedAscending
            }
            
            var dicCaseDetails:[[String:Any]]! = [[String:Any]]()
            
            for obj in arrCasedetails
            {
                dicCaseDetails.append([Constants.kstrcaseDetails : obj])
            }
            
            self.newResponse[Constants.kstrPreAssembly] = dicCaseDetails
            
            self.tray = self.newResponse as? Dictionary<String, Any>
            
            self.tray?[Constants.kstrtrayId] = self.newResponse[Constants.kstrid]!
            
            if self.identifyVC as String == Constants.kchooseVC
            {
                self.performSegue(withIdentifier: Constants.kstrAssembleTrayScannedImage , sender: nil)
            }
            else
            {
                self.performSegue(withIdentifier: Constants.kstrgotoEditImplant , sender: nil)
            }

        }
    }
    /*------------------------------------------------------
     below method will get called if user done scaning the bar code and clicks on accept button. How correct the barcode is, will be determined by calling the api getsearchtraybybarcode(For conttroller coming from chooseWorkFlowVC) and kvalidatescrewforproduct (for  AssembleTrayEditImplantViewController/ AssembleTrayEditImplantTray2ViewController VC)
     ------------------------------------------------------*/
    
    @IBAction func actionSave(_ sender: Any)
    {
        if scanBarcodeString.length == 0
        {
            return
        }

        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        /*------------------------------------------------------
         api calling for scaning the bar code
         
         Below api will be calling if class is being called from AssembleTrayEditImplantViewController/ AssembleTrayEditImplantTray2ViewController classes for scanning the implant
         ------------------------------------------------------*/

        if self.identifyVC as String == Constants.kstrgotoEditImplant
        { 
            let dicionaryForTray = NSMutableDictionary.init()
            
            /*------------------------------------------------------
             comment below line for commiting code. Just for testing purpose
             ------------------------------------------------------*/
            
//            dicionaryForTray.setValue("prod4", forKey: Constants.kstrtrayId)

            /*------------------------------------------------------
             uncomment below line for commiting code. For live scaning
             ------------------------------------------------------*/
            
            dicionaryForTray.setValue(scanBarcodeString, forKey: Constants.kstrtrayId)
            
            /*------------------------------------------------------
             OverrideHoles is coming from AssembleTrayEditImplantViewController/ AssembleTrayEditImplantTray2ViewController classes
             ------------------------------------------------------*/
            dicionaryForTray.setValue(trayType, forKey:"type")
            
            SurgeryViewWebservises().getScanPatient(dicionaryForTray as! [String:Any], Constants.ksearchimplantybybarcode,{(response,err) in
                
                CommanMethods.removeProgrssView(isActivity: true)

                /*------------------------------------------------------
                 On success the if the response msg returns "No Record Found" then just display the msg in alert no other activity
                 else if "Record Found", then pop the controller with calling delegate method validateScrewForProductApiResponse
                 else
                     display the msg
                 ------------------------------------------------------*/
                if let msg:String = response?[Constants.kstrmessage] as? String
                {
                    if(msg == Constants.kmsgNoRecord)
                    {
                        CommanMethods.alertView(message: msg as NSString , viewController: self, type: 1)
                    }
                    else if (msg == "Record Found")
                    {
                        /*------------------------------------------------------
                         On success the delegate method in AssembleTrayEditImplantViewController/ AssembleTrayEditImplantTray2ViewController classes will get called for setting the data in main array
                         ------------------------------------------------------*/

                        self.screwID = (response?["screw_id"]! as? String)! as NSString
                        
                        self.differentiateAlertView = 0
                        
                        CommanMethods.alertView(alertView: self.alertView, message: (response?["product_description"]! as? String)! as NSString, viewController: self, type: 1)
                    }
                    else
                    {
                        CommanMethods.alertView(message: msg as NSString , viewController: self, type: 1)
                    }
                }
                else
                {
                    CommanMethods.alertView(message: Constants.kMsgWrongResponse as NSString , viewController: self, type: 1)
                }

            })
        }
        
        /*------------------------------------------------------
         Below api will be calling if class is being called from ChooseWorkFlowVC to scan the tray type
         ------------------------------------------------------*/
        else
        {
            let dicionaryForTray = [Constants.kstrtrayId:scanBarcodeString] as Dictionary<String,Any>
            
//            let dicionaryForTray = [Constants.kstrtrayId:"bar1"] as Dictionary<String,Any>
            /*------------------------------------------------------
             The below api getsearchtraybybarcode will provide the screw details of assembly tray based on the type of tray. that screw details essentially consisting of assemblyDetails that is having screw details those are present,removed etc and also the type of tray that is being used in AssembleTrayScannedImgByBarcodeViewController class for initiating the controller based on tray type and screw details is to render in those controller
             ------------------------------------------------------*/
            
            SurgeryViewWebservises().getScanPatient(dicionaryForTray, Constants.ksearchtraybybarcodeforassembletray,{(response,err) in
             
                CommanMethods.removeProgrssView(isActivity: true)
                
                if let msg:String = response?[Constants.kstrmessage] as? String
                {
                    if(msg == Constants.kstrFailed)
                    {
                        CommanMethods.removeProgrssView(isActivity: true)
                        
                        CommanMethods.alertView(message: Constants.kMsgWrongResponse as NSString , viewController: self, type: 1)
                        return
                    }
                    
                }
                
                if response != nil{
                    
                    let dicForAlert = response![Constants.kproduct] as? [String:Any]
                    
                    self.trayType = (dicForAlert?["type"] as? NSString)!
                    
                    let msg:String = (dicForAlert?[Constants.kdescription] as? String)!
                    
                    self.newResponse = NSMutableDictionary.init(dictionary: response!)
                    
                    self.dictImagData = NSMutableDictionary.init(dictionary: response!)
                    
                    self.differentiateAlertView = 1
                    
                    CommanMethods.alertView(alertView: self.alertView, message: msg as NSString, viewController: self, type: 1)
                }
                else
                {
                    CommanMethods.alertView(message: Constants.kAlert_case_details_are_not_bind as NSString , viewController: self, type: 1)
                }
            })
        }
    }
 
    @IBAction func openMenu(_ sender: UIButton)
    {
      CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    /*------------------------------------------------------
     Below Method will be initiating the QRScannerController as child controller in the current view to give the scan bar code functionality
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
        if(segue.identifier == Constants.kstrAssembleTrayScannedImage)
        {
            let obj  =  segue.destination as! AssembleTrayScannedImgByBarcodeViewController
            
            obj.tray = tray
            
            obj.trayType = trayType
            
            obj.arrScrewData = arrScrewData
        }
        else if(segue.identifier == Constants.kstrgotoEditImplant)
        {
            let obj  =  segue.destination as! AssembleTrayEditImplantViewController
            
            obj.identifyVC = Constants.kstrScanBarCode as NSString
        }
    }
    
    /*------------------------------------------------------
     Below method will be called from AssembleTrayCloneImgPreviewViewController class that actually performing the unwide segue functionality
     ------------------------------------------------------*/
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue)
    {
       print(Constants.kSuccess)
    }
    
    /*------------------------------------------------------
     Below Method will be initiating the QRScannerController as child controller in the current view to give the scan bar code functionality again if user clicks on retake button This method will work same as actionStartSearchingBarcode
     ------------------------------------------------------*/    
    
    @IBAction func btnRetake(_ sender: Any)
    {
        let objQRScannerController = self.childViewControllers[0] as! QRScannerController
        
        objQRScannerController.captureSession?.startRunning()
    }
}
