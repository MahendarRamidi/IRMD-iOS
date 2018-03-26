//
//  ScanBarcodePatientDetailsViewController.swift
//  FDA
//
//  Created by Innovation Lab on 8/17/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class ScanBarcodePatientDetailsViewController: UIViewController
{
    var isForAddTray : Bool = false
    var tray :Dictionary <String,Any>! = nil
    var trayType : NSString = ""
    var arrTrayType : NSMutableArray = NSMutableArray.init()
     var caseId:Any! = nil
    @IBOutlet var txtPatientData: UITextField!
    @IBOutlet var txtSurgeon: UITextField!
    @IBOutlet var txtDate: UITextField!
    @IBOutlet var txtSurgery: UITextField!
    var dicForsaveTrays:[String:Any] = [:]
    @IBOutlet var btnPostSurgery: UIButton!
    @IBOutlet var btnPreSurgery: UIButton!
    var value:Any! = nil
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // we are taking the first one
       
        if let trayDetail = (tray[Constants.kstrPreAssembly] as? NSArray), trayDetail.count > 0{
            
            let dic1 = trayDetail.firstObject as! NSDictionary

            let dic = dic1[Constants.kstrcaseDetails] as! NSDictionary

            txtPatientData.text = (dic.value(forKey:Constants.kpatient) as! NSDictionary).value(forKey: Constants.kname) as? String
            
            txtSurgeon.text = dic.value(forKey:Constants.ksurgeonName) as? String
            
            txtDate.text = "\(dic.value(forKey:Constants.kstrcaseDate)!)"
            
            txtSurgery.text = (dic.value(forKey:Constants.ksurgeryType) as! NSDictionary)[Constants.ksurgeryType] as? String
        }
        else
        {
            btnPostSurgery.isHidden = true
            
            btnPreSurgery.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        /*------------------------------------------------------
         The below code will only execute if the flow is add tray flow as we need to hide the back button only when it is add tray flow.
         ------------------------------------------------------*/
        if isForAddTray
        {
            self.navigationItem.hidesBackButton = true;
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "GotoPreImage")
        {
            let objScanBarcodePreSurgeryViewController = segue.destination as! ScanBarcodePreSurgeryViewController
            objScanBarcodePreSurgeryViewController.trayType = trayType
            objScanBarcodePreSurgeryViewController.arrTrayType = arrTrayType
            objScanBarcodePreSurgeryViewController.trayNumber = 1;
            objScanBarcodePreSurgeryViewController.caseId = caseId
            objScanBarcodePreSurgeryViewController.tray = tray
            objScanBarcodePreSurgeryViewController.dicForsaveTrays = dicForsaveTrays
        }        
        
        if(segue.identifier == "GotoPostSurgery")
        {
            let objScanBarcodePostSurgeryViewController = segue.destination as! ScanBarcodePostSurgeryViewController
            objScanBarcodePostSurgeryViewController.tray = tray
            objScanBarcodePostSurgeryViewController.trayType = trayType
            objScanBarcodePostSurgeryViewController.value = ((dicForsaveTrays[Constants.kstrtrayId]! as! [Any])[0])
            objScanBarcodePostSurgeryViewController.arrTrayType = arrTrayType
            objScanBarcodePostSurgeryViewController.dicForsaveTrays = dicForsaveTrays
        }
    }
}
